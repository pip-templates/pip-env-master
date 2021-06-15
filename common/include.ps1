$path = $PSScriptRoot
if ($path -eq "") { $path = "." }

. "$($path)/config.ps1"
. "$($path)/convert.ps1"
. "$($path)/templates.ps1"
. "$($path)/values.ps1"
