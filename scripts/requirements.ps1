$ErrorActionPreference = "Stop"

# ----------------------------
# Paths
# ----------------------------
$BIN      = "$HOME\bin"
$CONFIG   = "$HOME\.config"
$FONT_DIR = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
$FONT_REG = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

New-Item -ItemType Directory -Force -Path $BIN, $CONFIG, $FONT_DIR | Out-Null

# ----------------------------
# Helper: persistent PATH update
# ----------------------------
function Add-ToUserPath {
    param ([string]$Dir)

    $current = [Environment]::GetEnvironmentVariable("PATH", "User")
    if (-not $current) { $current = "" }

    if ($current -notlike "*$Dir*") {
        [Environment]::SetEnvironmentVariable(
            "PATH",
            ($current.TrimEnd(";") + ";" + $Dir),
            "User"
        )
    }
}

# ----------------------------
# Helpers
# ----------------------------
function Download($Url, $Out) {
    Invoke-WebRequest $Url -OutFile $Out
}

function Extract-Zip($Zip, $Dest) {
    Expand-Archive $Zip $Dest -Force
}

function Install-Exe($Url, $Name) {
    Download $Url "$BIN\$Name.exe"
}

# ----------------------------
# Versions
# ----------------------------
$VERSIONS = @{
    nvim = "0.11.5"
    fd   = "10.3.0"
    rg   = "15.1.0"
    fzf  = "0.67.0"
    jq   = "1.8.1"
    yazi = "25.5.28"
    viu  = "1.6.1"
}

# ----------------------------
# Neovim
# ----------------------------
$tmp = Join-Path $env:TEMP ([guid]::NewGuid().ToString() + ".zip")
Download "https://github.com/neovim/neovim/releases/download/v$($VERSIONS.nvim)/nvim-win64.zip" $tmp
Extract-Zip $tmp $BIN
Remove-Item $tmp -Force

Add-ToUserPath "$BIN\nvim-win64\bin"

# ----------------------------
# fd
# ----------------------------
$tmp = Join-Path $env:TEMP ([guid]::NewGuid().ToString() + ".zip")
Download "https://github.com/sharkdp/fd/releases/download/v$($VERSIONS.fd)/fd-v$($VERSIONS.fd)-x86_64-pc-windows-msvc.zip" $tmp
Extract-Zip $tmp $BIN
Copy-Item "$BIN\fd-v$($VERSIONS.fd)-x86_64-pc-windows-msvc\fd.exe" $BIN -Force
Remove-Item "$BIN\fd-v$($VERSIONS.fd)-x86_64-pc-windows-msvc" -Recurse -Force
Remove-Item $tmp

# ----------------------------
# ripgrep
# ----------------------------
$tmp = Join-Path $env:TEMP ([guid]::NewGuid().ToString() + ".zip")
Download "https://github.com/BurntSushi/ripgrep/releases/download/$($VERSIONS.rg)/ripgrep-$($VERSIONS.rg)-x86_64-pc-windows-msvc.zip" $tmp
Extract-Zip $tmp $BIN
Copy-Item "$BIN\ripgrep-$($VERSIONS.rg)-x86_64-pc-windows-msvc\rg.exe" $BIN -Force
Remove-Item "$BIN\ripgrep-$($VERSIONS.rg)-x86_64-pc-windows-msvc" -Recurse -Force
Remove-Item $tmp

# ----------------------------
# fzf
# ----------------------------
$tmp = Join-Path $env:TEMP ([guid]::NewGuid().ToString() + ".zip")
Download "https://github.com/junegunn/fzf/releases/download/v$($VERSIONS.fzf)/fzf-$($VERSIONS.fzf)-windows_amd64.zip" $tmp
Extract-Zip $tmp $BIN
Remove-Item $tmp

# ----------------------------
# jq
# ----------------------------
Install-Exe "https://github.com/jqlang/jq/releases/download/jq-$($VERSIONS.jq)/jq-windows-amd64.exe" "jq"

# ----------------------------
# oh-my-posh
# ----------------------------
Install-Exe "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-windows-amd64.exe" "oh-my-posh"

# ----------------------------
# yazi + ya
# ----------------------------
$tmp = Join-Path $env:TEMP ([guid]::NewGuid().ToString() + ".zip")
Download "https://github.com/sxyazi/yazi/releases/download/v$($VERSIONS.yazi)/yazi-x86_64-pc-windows-msvc.zip" $tmp
Extract-Zip $tmp $BIN
Remove-Item $tmp

Add-ToUserPath "$BIN\yazi-x86_64-pc-windows-msvc"

# ----------------------------
# viu
# ----------------------------
Install-Exe "https://github.com/atanunq/viu/releases/download/v$($VERSIONS.viu)/viu-x86_64-pc-windows-msvc.exe" "viu"

# ----------------------------
# Meslo Nerd Font
# ----------------------------
$tmp = Join-Path $env:TEMP ([guid]::NewGuid().ToString() + ".zip")
Download "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip" $tmp
Extract-Zip $tmp $FONT_DIR
Remove-Item $tmp

Get-ChildItem "$FONT_DIR\*.ttf" | ForEach-Object {
    New-ItemProperty `
        -Path $FONT_REG `
        -Name $_.Name `
        -Value $_.FullName `
        -PropertyType String `
        -Force | Out-Null
}

# ----------------------------
# PowerShell profile
# ----------------------------
$profileDir = Split-Path $PROFILE.CurrentUserAllHosts
New-Item -ItemType Directory -Force -Path $profileDir | Out-Null

if (-not (Test-Path $PROFILE.CurrentUserAllHosts)) {
    New-Item -ItemType File -Path $PROFILE.CurrentUserAllHosts | Out-Null
}

Add-Content $PROFILE.CurrentUserAllHosts @'
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
Set-PSReadLineKeyHandler -Key Ctrl+t -ScriptBlock { fzf }
Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock { fzf }
'@
