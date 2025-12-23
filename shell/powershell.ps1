# ================================
# Oh My Posh setup
# ================================

# Fail fast
$ErrorActionPreference = "Stop"

# Ensure UTF-8 (required for icons/glyphs)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Path to Oh My Posh config
$OMP_CONFIG = "$HOME\.config\ohmyposh\base.json"

if (-not (Test-Path $OMP_CONFIG)) {
    Write-Error "Oh My Posh theme not found: $OMP_CONFIG"
    return
}

# Initialize Oh My Posh
oh-my-posh init pwsh --config $OMP_CONFIG | Invoke-Expression

# ================================
# Optional quality-of-life
# ================================

# Better tab completion
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Faster prompt redraw
$env:POSH_SESSION_ID = [guid]::NewGuid().ToString()

