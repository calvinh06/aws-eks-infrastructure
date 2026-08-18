[CmdletBinding()]
param(
    [string]$Repository = "C:\Users\calvinHarmon\terraform\eks\eks-terraform-infrastructure",
    [string]$Output = "C:\Users\calvinHarmon\terraform\eks\eks-terraform-infrastructure-source.zip"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path "$Repository\.git")) {
    throw "Not a Git repository: $Repository"
}

$changes = git -C $Repository status --short

if ($LASTEXITCODE -ne 0) {
    throw "Unable to inspect the repository."
}

if ($changes) {
    Write-Host "Warning: uncommitted files will not be included:" -ForegroundColor Yellow
    $changes | ForEach-Object { Write-Host "  $_" }
}

if (Test-Path $Output) {
    Remove-Item $Output
}

git -C $Repository archive `
    --format=zip `
    "--output=$Output" `
    --prefix="eks-terraform-infrastructure/" `
    HEAD

if ($LASTEXITCODE -ne 0) {
    throw "Git archive failed."
}

$archive = Get-Item $Output

Write-Host ""
Write-Host "Created source archive:" -ForegroundColor Green
Write-Host $archive.FullName
Write-Host "Size: $([math]::Round($archive.Length / 1MB, 2)) MB"