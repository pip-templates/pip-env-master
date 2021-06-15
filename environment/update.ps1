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
. "$($path)/../common/include.ps1"
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

$environmentType = Get-EnvMapValue -Map $config -Key "$ConfigPrefix.type"
$environmentVersion = Get-EnvMapValue -Map $config -Key "$ConfigPrefix.version"
$environmentTime = Get-Date -Format "o"

Set-EnvMapValue -Map $resources -Key "$ResourcePrefix.type" -Value $environmentType
Set-EnvMapValue -Map $resources -Key "$ResourcePrefix.version" -Value $environmentVersion
Set-EnvMapValue -Map $resources -Key "$ResourcePrefix.update_time" -Value $environmentTime
Write-EnvResources -ResourcePath $ResourcePath -Resources $resources
