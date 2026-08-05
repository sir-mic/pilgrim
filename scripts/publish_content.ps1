param(
  [Parameter(Mandatory = $true)]
  [string]$Repo,

  [Parameter(Mandatory = $true)]
  [string]$Token,

  [string]$BundlePath = "content\build\content.json",

  [string]$Branch = "gh-pages",

  [string]$Path = "content.json",

  [string]$Message = ""
)

# Publishes the signed content bundle to a GitHub Pages repository using the
# GitHub Contents API. Same operation as the admin tool's "Publish to GitHub
# Pages" button, for scripted or first-time setup.
#
# Requirements:
#   - The repository <owner>/<repo> already exists on GitHub.
#   - Pages is enabled: Settings > Pages > Deploy from branch > $Branch / root.
#   - $Token is a personal access token with `contents:write` scope.
#
# Example:
#   .\scripts\publish_content.ps1 -Repo sir-mic/pilgrim -Token ghp_xxx

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$bundle = Join-Path $root $BundlePath
if (-not (Test-Path -LiteralPath $bundle)) {
  throw "Bundle not found: $bundle. Run `dart run pilgrim_build build` first."
}

$raw = Get-Content -LiteralPath $bundle -Raw
$body = @{ message = $Message; content = $raw }
$encoded = [System.Text.Encoding]::UTF8.GetBytes($raw)
$base64 = [System.Convert]::ToBase64String($encoded)

$headers = @{
  Authorization = "token $Token"
  Accept        = "application/vnd.github+json"
  "Content-Type" = "application/json"
}

$api = "https://api.github.com/repos/$Repo/contents/$Path"
$get = Invoke-RestMethod -Uri "$api`?ref=$Branch" -Headers $headers -Method Get
$sha = if ($get.sha) { $get.sha } else { $null }

$payload = @{
  message = if ([string]::IsNullOrWhiteSpace($Message)) { "content: publish bundle" } else { $Message }
  content = $base64
  branch  = $Branch
}
if ($sha) { $payload.sha = $sha }

$null = Invoke-RestMethod -Uri $api -Headers $headers -Method Put -Body ($payload | ConvertTo-Json)
$owner = ($Repo -split '/')[0]
$name = ($Repo -split '/')[1]
Write-Host "Published to https://$owner.github.io/$name/$Path"
