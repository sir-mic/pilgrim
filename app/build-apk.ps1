$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

Write-Host 'Building mic release APK...'
flutter build apk --release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$src = Join-Path $PSScriptRoot 'build\app\outputs\flutter-apk\app-release.apk'
$dst = Join-Path $PSScriptRoot 'build\app\outputs\flutter-apk\mic-app.apk'

if (Test-Path $dst) { Remove-Item $dst }
Copy-Item $src $dst
Remove-Item $src -ErrorAction SilentlyContinue
Remove-Item "$src.sha1" -ErrorAction SilentlyContinue

$size = [Math]::Round((Get-Item $dst).Length / 1MB, 1)
Write-Host "Built: $dst ($size MB)"
