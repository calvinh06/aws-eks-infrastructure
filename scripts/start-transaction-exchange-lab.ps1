[CmdletBinding()]
param(
    [string]$ExpectedAwsAccountId = "728915381261",
    [string]$AwsRegion = "us-east-2",
    [string]$ClusterName = "transaction-exchange-dev",
    [string]$InfrastructureRepository = "C:\Users\calvinHarmon\terraform\eks\eks-terraform-infrastructure",
    [string]$ApplicationRepository = "C:\Users\calvinHarmon\terraform\eks\transaction-exchange-service\transaction-exchange-service",
    [switch]$Execute
)

$ErrorActionPreference = "Stop"

function Invoke-NativeCommand {
    param(
        [Parameter(Mandatory)]
        [string]$Command,

        [Parameter(Mandatory)]
        [string[]]$Arguments
    )

    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$Command failed with exit code $LASTEXITCODE."
    }
}

function Invoke-TerraformApply {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Directory
    )

    if (-not (Test-Path -LiteralPath $Directory -PathType Container)) {
        throw "Terraform directory for '$Name' was not found: $Directory"
    }

    $backendConfiguration = Join-Path $Directory "backend.hcl"
    if (-not (Test-Path -LiteralPath $backendConfiguration -PathType Leaf)) {
        throw "Backend configuration was not found for '$Name': $backendConfiguration"
    }

    Write-Host ""
    Write-Host "Starting $Name" -ForegroundColor Yellow
    Write-Host "Directory: $Directory"

    Invoke-NativeCommand -Command "terraform" -Arguments @(
        "-chdir=$Directory",
        "init",
        "-reconfigure",
        "-backend-config=backend.hcl"
    )

    Invoke-NativeCommand -Command "terraform" -Arguments @(
        "-chdir=$Directory",
        "apply",
        "-auto-approve"
    )

    Write-Host "Started $Name" -ForegroundColor Green
}

$callerAccountId = (& aws sts get-caller-identity --query Account --output text).Trim()
if ($LASTEXITCODE -ne 0) {
    throw "Unable to determine the active AWS account."
}

if ($callerAccountId -ne $ExpectedAwsAccountId) {
    throw "Refusing to continue. Active AWS account is $callerAccountId; expected $ExpectedAwsAccountId."
}

$terraformStacks = @(
    [pscustomobject]@{
        Name      = "VPC, NAT gateways, subnets, and endpoints"
        Directory = Join-Path $InfrastructureRepository "environments\dev\vpc"
    },
    [pscustomobject]@{
        Name      = "EKS cluster and managed nodes"
        Directory = Join-Path $InfrastructureRepository "environments\dev\eks-cluster"
    },
    [pscustomobject]@{
        Name      = "EKS add-ons"
        Directory = Join-Path $InfrastructureRepository "environments\dev\eks-addons"
    }
)

$kubernetesDirectory = Join-Path $ApplicationRepository "k8s\base"
if (-not (Test-Path -LiteralPath $kubernetesDirectory -PathType Container)) {
    throw "Kubernetes base directory was not found: $kubernetesDirectory"
}

Write-Host "AWS account verified: $callerAccountId" -ForegroundColor Green
Write-Host ""
Write-Host "Planned startup order:" -ForegroundColor Cyan
for ($index = 0; $index -lt $terraformStacks.Count; $index++) {
    Write-Host "  $($index + 1). $($terraformStacks[$index].Name)"
}
Write-Host "  4. Refresh kubeconfig for $ClusterName"
Write-Host "  5. Wait for worker nodes"
Write-Host "  6. Deploy transaction-exchange-service from the preserved ECR image"

foreach ($stack in $terraformStacks) {
    if (-not (Test-Path -LiteralPath $stack.Directory -PathType Container)) {
        throw "Required stack directory was not found: $($stack.Directory)"
    }
}

if (-not $Execute) {
    Write-Host ""
    Write-Host "Preview only. No resources were created." -ForegroundColor Yellow
    Write-Host "Rerun with -Execute to start the lab."
    exit 0
}

$confirmation = Read-Host "Type START LAB to recreate the development lab"
if ($confirmation -cne "START LAB") {
    throw "Confirmation did not match. No resources were created."
}

foreach ($stack in $terraformStacks) {
    Invoke-TerraformApply -Name $stack.Name -Directory $stack.Directory
}

Write-Host ""
Write-Host "Refreshing kubeconfig" -ForegroundColor Yellow
Invoke-NativeCommand -Command "aws" -Arguments @(
    "eks",
    "update-kubeconfig",
    "--region",
    $AwsRegion,
    "--name",
    $ClusterName
)

Write-Host "Waiting for worker nodes to become ready" -ForegroundColor Yellow
Invoke-NativeCommand -Command "kubectl" -Arguments @(
    "wait",
    "--for=condition=Ready",
    "nodes",
    "--all",
    "--timeout=10m"
)

Write-Host "Deploying the application" -ForegroundColor Yellow
Invoke-NativeCommand -Command "kubectl" -Arguments @(
    "apply",
    "-k",
    $kubernetesDirectory
)

Invoke-NativeCommand -Command "kubectl" -Arguments @(
    "rollout",
    "status",
    "deployment/transaction-exchange-service",
    "-n",
    "transaction-exchange",
    "--timeout=10m"
)

Write-Host ""
Invoke-NativeCommand -Command "kubectl" -Arguments @(
    "get",
    "pods",
    "-n",
    "transaction-exchange",
    "-o",
    "wide"
)

Write-Host ""
Write-Host "Lab startup completed successfully." -ForegroundColor Green
