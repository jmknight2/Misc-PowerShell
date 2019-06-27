Function Show-WindowsToast {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Body,

        [Parameter(Mandatory=$false)]
        [string]$Title,

        [Parameter(Mandatory=$false)]
        [System.DateTime]$ExpirationTime=(Get-Date).AddMinutes(5)
    )

    Begin {
        if($Title) {
            [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
            $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

            #Convert to .NET type for XML manipuration
            $toastXml = [xml] $template.GetXml()
            [void]$toastXml.GetElementsByTagName('text')[0].AppendChild($toastXml.CreateTextNode($Title))
            [void]$toastXml.GetElementsByTagName('text')[1].AppendChild($toastXml.CreateTextNode($Body))

            #Convert back to WinRT type
            $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
            $xml.LoadXml($toastXml.OuterXml)
        } else {
            [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
            $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01)

            #Convert to .NET type for XML manipuration
            $toastXml = [xml] $template.GetXml()
            [void]$toastXml.GetElementsByTagName('text')[0].AppendChild($toastXml.CreateTextNode($Body))

            #Convert back to WinRT type
            $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
            $xml.LoadXml($toastXml.OuterXml)
        }
    }

    Process {
        $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
        $toast.Tag = "PowerShell"
        $toast.Group = "PowerShell"
        $toast.ExpirationTime = $ExpirationTime

        $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
        $notifier.Show($toast);
    }

    End {}
}
