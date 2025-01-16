# Shell Profiles

This repository contains shell profiles for a variety of shells. They are simple and uniform, and can be used as a starting point for your own shell profile.
All of these shell profiles have support for non-color terminals, and will not break if the terminal does not support color codes. They also assign a random color to the prompt of each new device, subsequent logins will have the same color as the first login. In my experience, this helps to quickly identify which terminal is which when working with multiple terminals.

## Installation

To install a shell profile, you can either use the install scripts ([install.sh](install.sh) or [install.ps1](install.ps1)) or copy the contents of the shell profile to your shell profile file manually. The install script will look at the shells available on your system and install the profile for each shell.

> [!NOTE]
> The install scripts will create backups of your existing shell profile files before overwriting them, these are stored in the same directory as the original file with the extension `.bak`.

### Unix

To install the bash shell profile, run the following command:

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/pixnyb/profiles/main/install.sh)"
```

### Windows

To install the PowerShell shell profile on Windows, run the following command in PowerShell / Terminal:

```powershell
irm https://raw.githubusercontent.com/pixnyb/profiles/main/install.ps1 | iex
```

## Supported Shells

### Unix

| Shell        | Profile File                                                         | Remarks                                                           |
| ------------ | -------------------------------------------------------------------- | ----------------------------------------------------------------- |
| Bourne Shell | [.profile](.profile)                                                 | May be read by other shells if no other specific profile is found |
| Bash         | [.bash_profile](.bash_profile)                                       | Default shell for most Unix systems                               |
| Zsh          | [.zprofile](.zprofile)                                               | Default shell for macOS                                           |
| Fish         | [config.fish](config.fish)                                           |                                                                   |
| PowerShell   | [Microsoft.PowerShell_profile.ps1](Microsoft.PowerShell_profile.ps1) | Default shell for Windows                                         |

### Windows

| Shell      | Profile File                                                         | Remarks |
| ---------- | -------------------------------------------------------------------- | ------- |
| PowerShell | [Microsoft.PowerShell_profile.ps1](Microsoft.PowerShell_profile.ps1) |         |

## Customization

In order to manually change the color of a device, you can change the contents of the `.config/color` (or `%appdata%\PowerShell\color.txt` on Windows) file. The file should contain a single line with the color code you want to use. The possible colors are defined in the profile files themselves.

As far as the profile files themselves go, I may add support for more shells in the future, keep in mind that running the install script will overwrite any changes you have made to the profile files. If you want to keep your changes, you can copy the contents of the profile files to your own profile files or opt to manually install the new profile files.
