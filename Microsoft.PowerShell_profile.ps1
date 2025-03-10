# If there is no appdata, set it to the home directory + .config
$Separator = [System.IO.Path]::DirectorySeparatorChar

if ($env:APPDATA) {
    $ColorConfigPath = Join-Path $env:APPDATA "PowerShell${Separator}color.txt"
} else {
    $ColorConfigPath = Join-Path $env:HOME ".config${Separator}color.txt"
}

if (!(Test-Path (Split-Path $ColorConfigPath))) {
    New-Item -ItemType Directory -Path (Split-Path $ColorConfigPath) -Force | Out-Null
}

if (Test-Path $ColorConfigPath) {
    $COLOR = Get-Content $ColorConfigPath
} else {
    $colors = @("red", "green", "blue", "yellow", "cyan", "magenta")
    $COLOR = $colors[(Get-Random -Minimum 0 -Maximum $colors.Length)]
    $COLOR | Out-File -FilePath $ColorConfigPath -Encoding utf8
}

function Get-ColorCode($color) {
    switch ($color) {
        "red" { return 31 }
        "green" { return 32 }
        "yellow" { return 33 }
        "blue" { return 34 }
        "magenta" { return 35 }
        "cyan" { return 36 }
        default { return 31 }
    }
}

function prompt {
    $IS_ADMIN = $false
    # TODO: add exit code support
    if ($IsWindows) {
        $IS_ADMIN = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
        $HOSTNAME = $env:COMPUTERNAME
        $USER = $env:USERNAME
    } elseif ($IsLinux -or $IsMacOS) {
        $IS_ADMIN = (sudo -n true 2>/dev/null)
        $HOSTNAME = (hostname)
        $USER = (whoami)
    }

    $COLOR_SUPPORT = $true
    $RELATIVE_PATH = $PWD.Path

    if ($RELATIVE_PATH.StartsWith($HOME)) {
        $RELATIVE_PATH = "~" + $RELATIVE_PATH.Substring($HOME.Length)
    }

    if (!$COLOR_SUPPORT -or !$Host.UI.SupportsVirtualTerminal -or $env:NO_COLOR) {
        return "$env:COMPUTERNAME - $env:USERNAME - $RELATIVE_PATH PS> "
    }

    $hostSegment = "`e[0;$(Get-ColorCode $COLOR)m$HOSTNAME`e[0m"
    $userSegment = "`e[1;$(Get-ColorCode $COLOR)m$USER`e[0m"
    $pathSegment = "`e[90m$RELATIVE_PATH`e[0m"
    if ($IS_ADMIN) {
        $promptDelimiter = "`e[1;31mPS> `e[0m"
    } else {
        $promptDelimiter = "`e[90mPS> `e[0m"
    }

    return "$hostSegment `e[90m-`e[0m $userSegment `e[90m-`e[0m $pathSegment $promptDelimiter"
}