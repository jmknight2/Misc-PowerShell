Function New-TeamsVideoBackground {
    <#
        .Synopsis
        Uploads an image to Teams' default custom background directory. 

        .Description
        Uploads an image to Teams' default custom background directory, with support for file downloads via URL.

        .Parameter URL 
        The URL pointing to an image you want to use as a custom background.

        .Parameter Path
        The absolute file path to an image you would like to to use as a custom background.

        .Parameter FileName
        The desired name of the file. This overrides the current filename of the image.

        .EXAMPLE
        # Download a nice cat image from Wikipedia into the custom backgrounds directory.
        New-TeamsVideoBackground -URL 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg'

        .EXAMPLE
        # Move an existing image into the custom backgrounds directory, renaming it for clarity.
        New-TeamsVideoBackground -Path C:\Users\ttesterson\Pictures\superCoolImage11122334456.png -FileName 'Awesome Image'

        .NOTES
        Created By: Jon Knight (a.k.a. jmknight2: https://github.com/jmknight2)

        How to use your custom background images: https://www.theverge.com/2020/4/14/21220559/microsoft-teams-how-to-background-change-image-home-office
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ParameterSetName='url')]
        [String]$URL,

        [Parameter(Mandatory=$true, ParameterSetName='path')]
        [String]$Path,
        
        [Parameter(Mandatory=$false)]
        [String]$FileName
    )

    Begin {
        $BasePath = (Join-Path -Path $env:APPDATA -ChildPath 'Microsoft\Teams\Backgrounds\Uploads')
    }

    Process {
        if($URL) {
            if($URL.Split('/')[-1] -match "^.+(\.png|\.jpg|\.jpeg|\.gif)$") {
                Invoke-WebRequest -Uri $URL -Method Get -OutFile $(if($FileName){Join-Path -Path $BasePath -ChildPath "$($FileName).$($URL.Split('/')[-1].Split('.')[-1])"}else{Join-Path -Path $BasePath -ChildPath "$($URL.Split('/')[-1])"}) -UseBasicParsing
            } else {
                Write-Error "The provided URL doesn't resolve to a valid image file."
            }
        } elseif($Path) {
            if(Test-Path $Path) {
                $Item = Get-Item -Path $Path

                if($Item.Attributes -ne 'Directory' -and $Item.Extension -in @('.png','.jpg','.jpeg','.gif')) {
                    Copy-Item -Path $Path -Destination $BasePath

                    if($FileName) {
                        Rename-Item -Path "$(Join-Path -Path $BasePath -ChildPath $Item.Name)" -NewName "$($FileName)$($Item.Extension)" -Force
                    } 
                } else {
                    Write-Error "The provided file doesn't is not a valid image file."
                }
            } else {
                Write-Error "Invalid path provided."
            }
        }
    }

    End {}
}
