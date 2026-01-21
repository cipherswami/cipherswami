# ===== Admin check (run once at startup) =====
$isAdmin = (
    [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdmin) {
    $userColor = "Red"
    $symbol = "#"
} else {
    $userColor = "Green"
    $symbol = "$"
}

# ===== Environment settings =====
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1
$env:CONDA_CHANGEPS1 = "false"
$homePattern = [regex]::Escape($HOME)

# ===== Prompt =====
function prompt {
  Write-Host "PS " -NoNewline
  if ($env:CONDA_DEFAULT_ENV) {
    Write-Host "(" -NoNewline
    Write-Host "$env:CONDA_DEFAULT_ENV" -NoNewline -ForegroundColor Cyan
    Write-Host ")-" -NoNewline
  }
  if ($env:VIRTUAL_ENV) {
      Write-Host "(" -NoNewline
      Write-Host (Split-Path $env:VIRTUAL_ENV -Leaf) -NoNewline -ForegroundColor Cyan
      Write-Host ")-" -NoNewline
  }
  Write-Host "(" -NoNewline
  Write-Host "$env:USERNAME@$env:COMPUTERNAME" -NoNewline -ForegroundColor $userColor
  Write-Host ")-[" -NoNewline
  Write-Host ((Get-Location).Path -replace $homePattern, '~') -NoNewline -ForegroundColor Yellow
  Write-Host "]"
  Write-Host "$symbol" -NoNewline -ForegroundColor $userColor
  return " "
}

# ===== Common aliases =====
Set-Alias grep Select-String
Set-Alias touch New-Item
Set-Alias which where.exe

# ===== Alias: ll =====
function ll { Get-ChildItem -Force -Attributes !System @args }
