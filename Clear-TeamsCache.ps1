$Continue = [System.Windows.Forms.MessageBox]::Show("To clear cache, we must close temporarily close Teams.`nDo you wish to continue?","Warning", "YesNo" , "Warning" , "Button1")

if($Continue -eq 'Yes') {
    $TeamsProcess = Get-Process -Name Teams -ErrorAction SilentlyContinue
    $TeamsProcess | Stop-Process -Force

    $TotalKBToDelete = 0

    if(test-path -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\application cache\cache')) {
        Get-ChildItem -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\application cache\cache') -Recurse | Foreach-Object {
            $TotalKBToDelete += ($_.Length / 1024)
            Remove-Item $_ -Force
            Write-Verbose "Removed $($_.Name)"
        }
    }

    if(test-path -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\blob_storage')) {
        Get-ChildItem -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\blob_storage') -Recurse | Foreach-Object {
            $TotalKBToDelete += ($_.Length / 1024)
            Remove-Item $_ -Force
            Write-Verbose "Removed $($_.Name)"
        }
    }

    if(test-path -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\Cache')) {
        Get-ChildItem -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\Cache') -Recurse | Foreach-Object {
            $TotalKBToDelete += ($_.Length / 1024)
            Remove-Item $_ -Force
            Write-Verbose "Removed $($_.Name)"
        }
    }

    if(test-path -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\databases')) {
        Get-ChildItem -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\databases') -Recurse | Foreach-Object {
            $TotalKBToDelete += ($_.Length / 1024)
            Remove-Item $_ -Force
            Write-Verbose "Removed $($_.Name)"
        }
    }

    if(test-path -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\GPUcache')) {
        Get-ChildItem -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\GPUcache') -Recurse | Foreach-Object {
            $TotalKBToDelete += ($_.Length / 1024)
            Remove-Item $_ -Force
            Write-Verbose "Removed $($_.Name)"
        }
    }

    if(test-path -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\IndexedDB')) {
        (Get-ChildItem -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\IndexedDB') -Recurse).Where{$_.Extension -eq '.db'} | Foreach-Object {
            $TotalKBToDelete += ($_.Length / 1024)
            Remove-Item $_ -Force
            Write-Verbose "Removed $($_.Name)"
        }
    }

    if(test-path -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\Local Storage')) {
        Get-ChildItem -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\Local Storage') -Recurse | Foreach-Object {
            $TotalKBToDelete += ($_.Length / 1024)
            Remove-Item $_ -Force
            Write-Verbose "Removed $($_.Name)"
        }
    }

    if(test-path -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\tmp')) {
        Get-ChildItem -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\tmp') -Recurse | Foreach-Object {
            $TotalKBToDelete += ($_.Length / 1024)
            Remove-Item $_ -Force
            Write-Verbose "Removed $($_.Name)"
        }
    }

    Start-Process -FilePath (Join-Path $env:LOCALAPPDATA '\Microsoft\Teams\Update.exe') -ArgumentList '-processStart "Teams.exe"'

    [void]([System.Windows.Forms.MessageBox]::Show("Cache cleared successfully. `nWe removed $($TotalKBToDelete)KB of cache data.","Information", "Ok" , "Information" , "Button1"))
}
