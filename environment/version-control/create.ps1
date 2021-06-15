#!/usr/bin/env pwsh

param
(
    [Alias("Config")]
    [Parameter(Mandatory=$true, Position=0)]
    [string] $ConfigPath,

    [Parameter(Mandatory=$false, Position=1)]
    [string] $ConfigPrefix = "environment",

    [Alias("Resources")]
    [Parameter(Mandatory=$false, Position=2)]
    [string] $ResourcePath,

    [Parameter(Mandatory=$false, Position=3)]
    [string] $ResourcePrefix
)

$ErrorActionPreference = "Stop"

# Load support functions
$path = $PSScriptRoot
if ($path -eq "") { $path = "." }
. "$($path)/../../common/include.ps1"
$path = $PSScriptRoot
if ($path -eq "") { $path = "." }

# Set default parameter values
if (($ResourcePath -eq $null) -or ($ResourcePath -eq ""))
{
    $ResourcePath = ConvertTo-EnvResourcePath -ConfigPath $ConfigPath
}
if (($ResourcePrefix -eq $null) -or ($ResourcePrefix -eq "")) 
{ 
    $ResourcePrefix = $ConfigPrefix 
}

# Read config and resources
$config = Read-EnvConfig -ConfigPath $ConfigPath
$resources = Read-EnvResources -ResourcePath $ResourcePath

# Check that archive folder exists in the config folder
$archivePath = "$path/../../config/archive"
if (!(Test-Path $archivePath)) 
{ 
    New-Item -ItemType "directory" -Path $archivePath 
}

# Backup the config & resource files used
$currentDate = Get-Date -Format "yyyyMMdd"
$configVersion = Get-EnvMapValue -Map $config -Key "$ConfigPrefix.version"
$resourcesVersion = Get-EnvMapValue -Map $resources -Key "$ResourcePrefix.version"

Copy-Item $ConfigPath -Destination "$($archivePath)/$([io.path]::GetFileNameWithoutExtension($ConfigPath))-$($currentDate)-$($configVersion).json"
Copy-Item $ResourcePath -Destination "$($archivePath)/$([io.path]::GetFileNameWithoutExtension($ResourcePath))-$($currentDate)-$($resourcesVersion).json"
