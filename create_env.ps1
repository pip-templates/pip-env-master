#!/usr/bin/env pwsh

param
(
    [Alias("c", "Path")]
    [Parameter(Mandatory=$true, Position=0)]
    [string] $ConfigPath
)

$ErrorActionPreference = "Stop"

# Load support functions
$rootPath = $PSScriptRoot
if ($rootPath -eq "") { $rootPath = "." }
. "$($rootPath)/lib/include.ps1"
$rootPath = $PSScriptRoot
if ($rootPath -eq "") { $rootPath = "." }

# Create k8s cluster
. "$($rootPath)/src/install_k8s.ps1" $ConfigPath
# Check for error
if ($LastExitCode -ne 0) {
    Write-Error "Can't create k8s cluster. Watch logs above."
}

# Create db cluster
. "$($rootPath)/src/install_db.ps1" $ConfigPath
# Check for error
if ($LastExitCode -ne 0) {
    Write-Error "Can't create db cluster. Watch logs above."
}

# Peer db 
. "$($rootPath)/src/peer_db.ps1" $ConfigPath
# Check for error
if ($LastExitCode -ne 0) {
    Write-Error "Can't peer db cluster. Watch logs above."
}

# Install k8s components
. "$($rootPath)/common/install_k8s_components.ps1" $ConfigPath
# Check for error
if ($LastExitCode -ne 0) {
    Write-Error "Error while installing kubernetes components. Watch logs above."
}
