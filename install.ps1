# Windows install wizard. Requires Docker Desktop with Linux containers.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  Write-Error "Docker Desktop is required. Install it and enable Linux containers."
}

if (-not (Test-Path .env)) {
  Copy-Item .env.example .env
  $pass = -join ((48..57) + (97..102) | Get-Random -Count 24 | ForEach-Object {[char]$_})
  (Get-Content .env) -replace '^VNC_PASSWORD=.*', "VNC_PASSWORD=$pass" | Set-Content .env
  Write-Host "Generated VNC password: $pass"
  $domain = Read-Host "Domain (localhost for local testing)"
  if ($domain) { (Get-Content .env) -replace '^DOMAIN=.*', "DOMAIN=$domain" | Set-Content .env }
}

docker compose up -d --build
Write-Host "Done. Open http://127.0.0.1:6080/vnc.html"
