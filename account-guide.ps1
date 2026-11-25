param([string]$Provider = "aws")
$urls = @{
  aws = "https://signin.aws.amazon.com/signup"
  oracle = "https://www.oracle.com/cloud/free/"
  github = "https://github.com/codespaces"
  cloudflare = "https://dash.cloudflare.com/sign-up"
}
if (-not $urls.ContainsKey($Provider)) { Write-Error "Use: aws | oracle | github | cloudflare" }
Write-Host "Opening $($urls[$Provider])"
Write-Host "Checklist: create ONE account, enable MFA, accept the terms, then configure the CLI yourself."
Write-Host "Do not paste passwords or verification codes into chat or files."
Start-Process $urls[$Provider]
