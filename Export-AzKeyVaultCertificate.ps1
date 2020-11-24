#Requires -Modules Az.Accounts,Az.KeyVault

Function Export-AzKeyVaultCertificate {
    <#
        .SYNOPSIS
        Exports an Azure KeyVault Certificate to a PFX file.

        .DESCRIPTION
        Exports an Azure KeyVault Certificate to a PFX file.

        .PARAMETER VaultName
        The name of the Azure KeyVault where the certificate resides.

        .PARAMETER CertificateName
        The name of the Azure KeyVault certificate you wish to export.

        .PARAMETER Password
        The password which will be used to lock the PFX file. If the parameter is not specifed, the PFX file will 
        not be password protected, which is generally very unsecure.

        .PARAMETER Path
        The filepath where you wish to store the exported PFX file. If not specified, this defaults to the current 
        location.

        .PARAMETER IncludeFullChain
        If present, this switch will export the full chain along with the base certificate. This results in a 
        slightly larger file size

        .EXAMPLE
        Export a basic cert without the full-chain and lock it with a password:

        Export-AzKeyVaultCertificate -VaultName 'my-cool-vault' -CertificateName 'my-awesome-cert' -Path C:\Users\jmknight\Desktop -Password (ConvertTo-SecureString -AsPlainText 'password123' -Force)

        .NOTES
        Author: Jon M. Knight

        This cmdlet assumes you have already run Connect-AzAccount to connect to your Azure tenant.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$VaultName,

        [Parameter(Mandatory=$true)]
        [string]$CertificateName,

        [Parameter(Mandatory=$false)]
        [securestring]$Password,

        [Parameter(Mandatory=$false)]
        [string]$Path,

        [Parameter(Mandatory=$false)]
        [switch]$IncludeFullChain
    )

    Begin {
        $CertPath = if (![string]::IsNullOrWhiteSpace($Path)) {
                        if ($Path.Contains('.pfx')) {
                            $Path
                        } else {
                            Join-Path $Path "$($CertificateName).pfx"
                        }
                    } else {
                        "$($CertificateName).pfx"
                    }
    }

    Process {
        $secret = Get-AzKeyVaultSecret -VaultName $vaultName -Name $CertificateName
        $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue))
        $secretByte = [Convert]::FromBase64String($secretValueText)
        $x509Cert = if ($IncludeFullChain.IsPresent) {
                        New-Object 'System.Security.Cryptography.X509Certificates.X509Certificate2Collection'
                    } else {
                        New-Object 'System.Security.Cryptography.X509Certificates.X509Certificate2'
                    }
        $x509Cert.Import($secretByte, "", "Exportable,PersistKeySet")
        $pfxFileByte = $x509Cert.Export(
            [System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12,
            $(
                if ([string]::IsNullOrWhiteSpace($Password)) {
                    $null
                } else {
                    [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
                }
            )
        )
    }

    End {
        # Write to a file
        [System.IO.File]::WriteAllBytes($CertPath, $pfxFileByte)
    }
}