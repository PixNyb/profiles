#!/bin/sh

# Check if the home directory is available
if [ ! -d "$HOME" ]; then
    echo "Home directory not found, exiting..."
    exit 1
fi

# Get the list of available shells
available_shells=$(grep -vE '^\s*#|^\s*$' /etc/shells)

# Check and install profiles based on available shells
for shell in $available_shells; do
    case $shell in
    */sh | */ksh | */bash | */zsh | */csh | */tcsh | */fish | */pwsh | */dash)
        echo "Installing profile for $shell"
        if [ -f $HOME/.profile ]; then
            cp $HOME/.profile $HOME/.profile.bak
        fi
        cp .profile $HOME/.profile
        ;;
    */bash)
        echo "Installing profile for $shell"
        if [ -f $HOME/.bash_profile ]; then
            cp $HOME/.bash_profile $HOME/.bash_profile.bak
        fi
        cp .bash_profile $HOME/.bash_profile
        ;;
    */zsh)
        echo "Installing profile for $shell"
        if [ -f $HOME/.zprofile ]; then
            cp $HOME/.zprofile $HOME/.zprofile.bak
        fi
        cp .zprofile $HOME/.zprofile
        ;;
    */csh | */tcsh)
        echo "There is no profile for $shell"
        ;;
    */fish)
        echo "Installing profile for $shell"
        mkdir -p $HOME/.config/fish
        if [ -f $HOME/.config/fish/config.fish ]; then
            cp $HOME/.config/fish/config.fish $HOME/.config/fish/config.fish.bak
        fi
        cp config.fish $HOME/.config/fish/config.fish
        ;;
    */pwsh)
        echo "Installing profile for $shell"
        mkdir -p $HOME/.config/powershell
        if [ -f $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1 ]; then
            cp $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1 $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1.bak
        fi
        cp Microsoft.PowerShell_profile.ps1 $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1
        ;;
    *)
        echo "Unknown shell $shell, skipping..."
        ;;
    esac
done
