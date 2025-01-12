#!/usr/bin/env pwsh

$GIT_CMD = Get-Command git -ErrorAction SilentlyContinue
if (-not $GIT_CMD) {
    Write-Error 'Error: git is not installed.'
    exit 1
}

# Install the profile files
$Separator = [System.IO.Path]::DirectorySeparatorChar
try {
    git clone https://github.com/pixnyb/profiles.git "$HOME${Separator}.profiles"
} catch {
    Write-Error 'Error: failed to clone the repository.'
    exit 1
}

$WorkDir = Get-Location
Set-Location -Path "$HOME${Separator}.profiles"
# Execute the load.ps1 script
& "${PSScriptRoot}${Separator}load.ps1"

# Remove the cloned repository
Set-Location -Path $WorkDir
Remove-Item -Recurse -Force "$HOME${Separator}.profiles"

Write-Output 'Profile files for the appropriate shells have been installed, please restart your shell.'
