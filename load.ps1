# Define the source and destination paths
$Separator = [System.IO.Path]::DirectorySeparatorChar
$sourcePath = "$PSScriptRoot${Separator}Microsoft.PowerShell_profile.ps1"
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