function ConvertObjectToHashtable 
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory=$False, Position = 0, ValueFromPipeline=$True)]
        [Object] $InputObject = $null
    )
    process 
    {
        if ($null -eq $InputObject) { return $null }

        if ($InputObject -is [Hashtable]) 
        {
            $InputObject
        } 
        elseif ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) 
        {
            $collection = 
            @(
                foreach ($object in $InputObject) { ConvertObjectToHashtable $object }
            )

            Write-Output -NoEnumerate $collection
        }
        elseif ($InputObject -is [psobject]) 
        {
            $hash = @{}

            foreach ($property in $InputObject.PSObject.Properties) 
            {
                $hash[$property.Name] = ConvertObjectToHashtable $property.Value
            }

            $hash
        }
        else 
        {
            $InputObject
        }
    }
}


function ConvertOutputToResources
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [Array[]] $Outputs
    )

    # define keys fo key and value 
    $keyParam = 'OutputKey'
    $valueParam = 'OutputValue'
    $newOutputs = New-Object System.Collections.Hashtable

    if ($null -eq $Outputs) { 
        Write-Host 'Outputs is null'

        return $null 
    }

    foreach($item in $Outputs) {
        $newKey = ($item | Select-Object -ExpandProperty $keyParam)
        $newValue =  ($item | Select-Object -ExpandProperty $valueParam)

        if ($null -ne $newKey) {
            $newOutputs[$newKey] = $newValue
        }
    } 
 
    return $newOutputs
}
