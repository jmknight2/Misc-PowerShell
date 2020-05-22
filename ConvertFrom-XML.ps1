Function ConvertFrom-XML {
    <#
        .Synopsis
        Converts an XML object into a PSCustomObject. 

        .Description
        Converts an XML object into a PSCustomObject, making it much easier to parse through, or visually understand. Works on XMLDocuments and XMLNodes

        .Parameter XMLBlob
        The XML object you wish to convert.

        .EXAMPLE
        # Convert an XML response from an API
        Invoke-RestMethod -Uri 'https://api.somexmlapi.com/stuff' | ConvertFrom-XML

        .NOTES
        Created By: Jon Knight (a.k.a. jmknight2: https://github.com/jmknight2)
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline)]
        [Object]$XMLBlob
    )

    Begin {}

    Process {
        $Obj = [PSCustomObject]@{}

        $Properties = $XMLBlob | Get-Member | Where-Object {$_.MemberType -eq 'Property'}

        foreach($Prop in $Properties) {
            if($Prop.Definition.Split(' ')[0] -like '*xml*') {
                $Obj | Add-Member -NotePropertyName $Prop.Name -NotePropertyValue (ConvertFrom-XML -XMLBlob $XMLBlob.$($Prop.Name))
            } elseif($Prop.name -like '*#cdata-section*') {
                $Dataval = $XMLBlob.$($Prop.Name)
            } else {
                $Obj | Add-Member -NotePropertyName $Prop.Name -NotePropertyValue $XMLBlob.$($Prop.Name)
            }
        }

        if($Dataval) {
            $Dataval
        } else {
            $Obj
        }
    }

    End {}
}
