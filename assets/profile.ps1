function prompt {

    Write-Host "PS " -NoNewline

    $user = $env:USERNAME
    $hostname = $env:COMPUTERNAME
    $path = (Get-Location).Path
    $homep = [Environment]::GetFolderPath('UserProfile')
    $wdir = if ($path -like "$homep*") { $path.Replace($homep, "~") } else { $path }

    # Admin check
    $isAdmin = (
        [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($isAdmin) {
        $userColor = "Red"
        $symbol = "#"
    } else {
        $userColor = "Green"
        $symbol = "$"
    }

    # Virtual VENV
    $env:VIRTUAL_ENV_DISABLE_PROMPT = 1
    $env:CONDA_CHANGEPS1 = 0

    if ($env:CONDA_DEFAULT_ENV) {
        $venv = $env:CONDA_DEFAULT_ENV
    } elseif ($env:VIRTUAL_ENV) {
        $venv = $env:VIRTUAL_ENV
        $venv = if ($venv) { "$(Split-Path $venv -Leaf)" } else { "" }
    } else {
        $venv = ""
    }

    if ($venv) {
      Write-Host "(" -NoNewline
      Write-Host "$venv" -NoNewline -ForegroundColor Cyan
      Write-Host ")-" -NoNewline
    }

    Write-Host "(" -NoNewline
    Write-Host "$user@$hostname" -NoNewline -ForegroundColor $userColor
    Write-Host ")-[" -NoNewline
    Write-Host "$wdir" -NoNewline -ForegroundColor Yellow
    Write-Host "]"
    Write-Host "$symbol" -NoNewline
    return " "
}

# Common aliases
Set-Alias grep Select-String
Set-Alias touch New-Item
Set-Alias which where.exe

# Alias: ll - Shows all most all files
function ll {
    Get-ChildItem -Force -Attributes !System @args
}

# Alias: cd - Change to home or given directory
Remove-Item Alias:cd
function cd {
    if ($args.Count -eq 0) {
        Set-Location ~
    } else {
        Set-Location @args
    }
}
