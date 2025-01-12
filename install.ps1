#!/usr/bin/env pwsh

$GIT_CMD = Get-Command git -ErrorAction SilentlyContinue
if (-not $GIT_CMD) {
    Write-Error 'Error: git is not installed.'
    exit 1
}

# Install the profile files
$Separator = [System.IO.Path]::DirectorySeparatorChar
try {
    git clone https://github.com/pixnyb/profiles.git "$HOME${Separator}.profiles" -q
} catch {
    Write-Error 'Error: failed to clone the repository.'
    exit 1
}

$WorkDir = Get-Location
Set-Location -Path "$HOME${Separator}.profiles"

# Start of load.ps1, Microsoft security doesn't permit the use of current location scripts
# Define the source and destination paths
$Separator = [System.IO.Path]::DirectorySeparatorChar
$sourcePath = ".${Separator}Microsoft.PowerShell_profile.ps1"
$destinationPath = "$PROFILE"

# Create the destination directory if it doesn't exist
$destinationDir = [System.IO.Path]::GetDirectoryName($destinationPath)
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force
}

# If there already is a profile script, rename it
if (Test-Path -Path $destinationPath) {
    $backupPath = "$destinationPath.bak"
    Move-Item -Path $destinationPath -Destination $backupPath -Force
}

# Copy the profile script to the destination
Copy-Item -Path $sourcePath -Destination $destinationPath -Force

Write-Output "Installing profile for PowerShell"
# End of load.ps1

# Remove the cloned repository
Set-Location -Path $WorkDir
Remove-Item -Recurse -Force "$HOME${Separator}.profiles"

Write-Output 'Profile files for the appropriate shells have been installed, please restart your shell.'
