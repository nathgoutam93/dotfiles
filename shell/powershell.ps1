# ================================
# Editor
# ================================

$env:EDITOR = "nvim"

# ================================
# Yazi helper (PowerShell)
# ================================

function y {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}

# ================================
# Prompt (oh-my-posh, PowerShell)
# ================================

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$HOME\.config\ohmyposh\base.json" | Invoke-Expression
}

