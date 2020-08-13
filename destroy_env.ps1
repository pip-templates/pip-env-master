#!/usr/bin/env pwsh

param
(
    [Alias("c", "Path")]
    [Parameter(Mandatory=$false, Position=0)]
    [string] $ConfigPath
)

$ErrorActionPreference = "Stop"

# Load support functions
$rootPath = $PSScriptRoot
if ($rootPath -eq "") { $rootPath = "." }
. "$($rootPath)/lib/include.ps1"
$rootPath = $PSScriptRoot
if ($rootPath -eq "") { $rootPath = "." }

# Destroy k8s cluster
. "$($rootPath)/src/destroy_k8s.ps1" $ConfigPath
# Check for error
if ($LastExitCode -ne 0) {
    Write-Error "Can't destroy k8s. Watch logs above."
}

# Unpeer db 
. "$($rootPath)/src/unpeer_db.ps1" $ConfigPath
# Check for error
if ($LastExitCode -ne 0) {
    Write-Error "Can't unpeer db cluster. Watch logs above."
}

# Destroy db cluster
. "$($rootPath)/src/destroy_db.ps1" $ConfigPath
# Check for error
if ($LastExitCode -ne 0) {
    Write-Error "Can't destroy db cluster. Watch logs above."
}
