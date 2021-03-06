Function Sort-PsCustomObject {
    <#
    .SYNOPSIS
    Sorts the properties of a given PSCustom Object.

    .Parameter InputObject
    The PSCustomObject which you want to sort.

    .Notes
    Complete attribution of this code goes to StackOverflow user: mklement0
    Source: https://stackoverflow.com/a/44056862/7838933
    #>

    param(
        [Parameter(Mandatory=$true,ValueFromPipeline)]
        [PSCustomObject]$InputObject
    )

    Begin {}

    Process {
        # Build an ordered hashtable of the property-value pairs
        $sortedProps = [ordered]@{}
        Get-Member -Type  NoteProperty -InputObject $InputObject | Sort-Object Name | ForEach-Object {$sortedProps[$_.Name] = $InputObject.$($_.Name)}

        # Create a new object that receives the sorted properties
        $ObjSortedProperties = New-Object PSCustomObject
        Add-Member -InputObject $ObjSortedProperties -NotePropertyMembers $sortedProps
    }

    End {
        $ObjSortedProperties
    }
}
