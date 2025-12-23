$ErrorActionPreference = "Stop"

$DOTFILES = "$HOME\dotfiles"

$LOCAL_CONFIG   = $env:LOCALAPPDATA
$ROAMING_CONFIG = $env:APPDATA

function Link {
    param (
        [Parameter(Mandatory)]
        [string]$Source,

        [Parameter(Mandatory)]
        [string]$Destination
    )

    if (-not (Test-Path $Source)) {
        Write-Host "skip (missing): $Source"
        return
    }

    if (Test-Path $Destination) {
        Remove-Item $Destination -Recurse -Force
    }

    if (Test-Path $Source -PathType Container) {
        # Directories: use junctions (no admin required)
        New-Item -ItemType Junction -Path $Destination -Target $Source | Out-Null
        Write-Host "junction $Destination → $Source"
    } else {
        # Files: use hard links (no admin required, same drive only)
        try {
            New-Item -ItemType HardLink -Path $Destination -Target $Source | Out-Null
            Write-Host "hardlink $Destination → $Source"
        } catch {
            Write-Error "Cannot create hardlink: $Destination. Source and destination must be on the same drive."
            exit 1
        }
    }
}

# --------------------
# Neovim
# --------------------
Link "$DOTFILES\nvim" "$LOCAL_CONFIG\nvim"

# --------------------
# Yazi
# --------------------
Link "$DOTFILES\yazi" "$ROAMING_CONFIG\yazi"

# --------------------
# Oh My Posh (themes/config)
# --------------------
Link "$DOTFILES\ohmyposh" "$HOME\.config\ohmyposh"

# --------------------
# PowerShell profile
# --------------------
$psProfileSource = "$DOTFILES\shell\powershell.ps1"

if (Test-Path $psProfileSource) {
    $profileDir = Split-Path $PROFILE.CurrentUserAllHosts
    New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
    Link $psProfileSource $PROFILE.CurrentUserAllHosts
}

# --------------------
# Git
# --------------------
Link "$DOTFILES\git\gitconfig" "$HOME\.gitconfig"

Write-Host "dotfiles linking completed (Windows)"

