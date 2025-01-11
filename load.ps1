# Define the source and destination paths
$sourcePath = "./Microsoft.PowerShell_profile.ps1"
$destinationPath = "$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"

# Create the destination directory if it doesn't exist
$destinationDir = [System.IO.Path]::GetDirectoryName($destinationPath)
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force
}

# Copy the profile script to the destination
Copy-Item -Path $sourcePath -Destination $destinationPath -Force

Write-Output "Installing profile for PowerShell"