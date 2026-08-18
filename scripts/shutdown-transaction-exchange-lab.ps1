[CmdletBinding()]
param(
    [string]$ExpectedAwsAccountId = "728915381261",
    [string]$InfrastructureRepository = "C:\Users\calvinHarmon\terraform\eks\eks-terraform-infrastructure",
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

function Invoke-TerraformDestroy {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Directory
    )

    if (-not (Test-Path -LiteralPath $Directory -PathType Container)) {
        throw "Terraform directory for '$Name' was not found: $Directory"
    }

    Write-Host ""
    Write-Host "Destroying $Name" -ForegroundColor Yellow
    Write-Host "Directory: $Directory"

    Invoke-NativeCommand -Command "terraform" -Arguments @(
        "-chdir=$Directory",
        "destroy",
        "-auto-approve"
    )

    Write-Host "Destroyed $Name" -ForegroundColor Green
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
        Name      = "EKS add-ons"
        Directory = Join-Path $InfrastructureRepository "environments\dev\eks-addons"
    },
    [pscustomobject]@{
        Name      = "EKS cluster and managed nodes"
        Directory = Join-Path $InfrastructureRepository "environments\dev\eks-cluster"
    },
    [pscustomobject]@{
        Name      = "VPC, NAT gateways, subnets, and endpoints"
        Directory = Join-Path $InfrastructureRepository "environments\dev\vpc"
    }
)

Write-Host "AWS account verified: $callerAccountId" -ForegroundColor Green
Write-Host ""
Write-Host "Planned destruction order:" -ForegroundColor Cyan
Write-Host "  1. Kubernetes namespace transaction-exchange"
for ($index = 0; $index -lt $terraformStacks.Count; $index++) {
    Write-Host "  $($index + 2). $($terraformStacks[$index].Name)"
}
Write-Host ""
Write-Host "Preserved: ECR image, security foundation, bootstrap state, and deployment roles." -ForegroundColor Cyan

foreach ($stack in $terraformStacks) {
    if (-not (Test-Path -LiteralPath $stack.Directory -PathType Container)) {
        throw "Required stack directory was not found: $($stack.Directory)"
    }
}

if (-not $Execute) {
    Write-Host ""
    Write-Host "Preview only. No resources were deleted." -ForegroundColor Yellow
    Write-Host "Rerun with -Execute to perform the shutdown."
    exit 0
}

$confirmation = Read-Host "Type DESTROY LAB to remove the development lab"
if ($confirmation -cne "DESTROY LAB") {
    throw "Confirmation did not match. No resources were deleted."
}

Write-Host ""
Write-Host "Deleting the application namespace before removing the cluster" -ForegroundColor Yellow
Invoke-NativeCommand -Command "kubectl" -Arguments @(
    "delete",
    "namespace",
    "transaction-exchange",
    "--ignore-not-found=true",
    "--wait=true",
    "--timeout=5m"
)

foreach ($stack in $terraformStacks) {
    Invoke-TerraformDestroy -Name $stack.Name -Directory $stack.Directory
}

Write-Host ""
Write-Host "Lab shutdown completed successfully." -ForegroundColor Green
Write-Host "ECR, security, bootstrap remote state, and deployment roles were preserved for the next lab session."
