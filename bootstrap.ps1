$ErrorActionPreference = "Stop"

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptRoot

# ----------------------------
# Requirements
# ----------------------------
& "$ScriptRoot\scripts\requirements.ps1"

# ----------------------------
# OS dispatch (robust)
# ----------------------------
$platform = [System.Environment]::OSVersion.Platform

switch ($platform) {
    "Win32NT" {
        & "$ScriptRoot\scripts\windows.ps1"
    }
    default {
        throw "Unsupported OS: $platform"
    }
}

