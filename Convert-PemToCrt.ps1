Function Convert-PemToCrt {
    <#
        .SYNOPSIS
        Converts a PEM format certificate to CRT format.

        .DESCRIPTION
        Converts a PEM format certificate to one or more CRT files and a single KEY file.

        .PARAMETER InputFile
        The file path to the PEM file which you would like to convert.

        .PARAMETER CertificateName
        The file name you would like to give the output CRT and KEY files.

        .PARAMETER OutputPath
        The file path to a directory where you'd like to store the created files.

        .PARAMETER SingleBundle
        If present, this switch will output the public key, along with any root certificates to the same crt file.

        .EXAMPLE
        Convert a PEM file and store the resulting files on the desktop:

        Convert-PemToCrt -InputFile C:\Users\jmknight\star-example-com.pem -CertificateName 'star-example-com' -OutputPath 'C:\Users\jmknight\Desktop'

        .NOTES
        Author: Jon M. Knight.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$InputFile,

        [Parameter(Mandatory=$true)]
        [string]$CertificateName,

        [Parameter(Mandatory=$true)]
        [string]$OutputPath,

        [Parameter(Mandatory=$false)]
        [switch]$SingleBundle
    )

    Begin {
        $PemContents = (Get-content -Path $InputFile -ErrorAction Stop) -join ''
    }


    Process {
        $PrivateKey = ($PemContents -split '-----END PRIVATE KEY-----')[0].trim('-----BEGIN PRIVATE KEY-----').replace('-----BEGIN CERTIFICATE-----','')

        for($i=64;$i -lt $PrivateKey.length;$i+=65) {
            $PrivateKey = $PrivateKey.Insert($i,"`n")
        }

        "-----BEGIN PRIVATE KEY-----`n$($PrivateKey)`n-----END PRIVATE KEY-----" | Out-File -FilePath (Join-Path $OutputPath "$($CertificateName).key")

        $CertSplit = ($PemContents -split '-----END PRIVATE KEY----------BEGIN CERTIFICATE-----|-----END CERTIFICATE-----')

        $CertArray = $CertSplit[1..$CertSplit.Count].replace('-----BEGIN CERTIFICATE-----','').where{![string]::IsNullOrWhiteSpace($_)}

        if (!$SingleBundle.isPresent) {
            $BaseCert = $CertArray[0]

            for($i=64;$i -lt $BaseCert.length;$i+=65) {
                $BaseCert = $BaseCert.Insert($i,"`n")
            }

            "-----BEGIN CERTIFICATE-----`n$($BaseCert)`n-----END CERTIFICATE-----`n" | Out-File -FilePath (Join-Path $OutputPath "$($CertificateName).crt")

            $CertArray = $CertArray[1..$CertArray.Count]
        }

        if ($CertArray.Count -gt 1) {
            $CertBundle = foreach ($Cert in $CertArray) {
                for($i=64;$i -lt $Cert.length;$i+=65) {
                    $Cert = $Cert.Insert($i,"`n")
                }

                "-----BEGIN CERTIFICATE-----`n$($Cert)`n-----END CERTIFICATE-----`n"
            }

            $CertBundle | Out-File -FilePath (Join-Path $OutputPath $(if($SingleBundle.IsPresent){"$($CertificateName).crt"}else{"full-chain.crt"}))
        }
    }

    End {}
}
