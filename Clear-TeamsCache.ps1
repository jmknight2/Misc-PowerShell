$CachePaths = @(
    '\Microsoft\teams\application cache\cache',
    '\Microsoft\teams\blob_storage',
    '\Microsoft\teams\Cache',
    '\Microsoft\teams\databases',
    '\Microsoft\teams\GPUcache',
    '\Microsoft\teams\Local Storage',
    '\Microsoft\teams\tmp'
)

$Continue = [System.Windows.Forms.MessageBox]::Show("To clear cache, we must close temporarily close Teams.`nDo you wish to continue?","Warning", "YesNo" , "Warning" , "Button1")

if($Continue -eq 'Yes') {
    $TeamsProcess = Get-Process -Name Teams -ErrorAction SilentlyContinue
    $TeamsProcess | Stop-Process -Force

    $TotalKBToDelete = 0

    foreach($Path in $CachePaths) {
        if(test-path -Path (Join-Path $($env:APPDATA) $Path)) {
            Get-ChildItem -Path (Join-Path $($env:APPDATA) $Path) -Recurse | Foreach-Object {
                $TotalKBToDelete += ($_.Length / 1024)
                $_ | Remove-Item -Force
                Write-Verbose "Removed $($_.Name)"
            }
        }
    }

    if(test-path -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\IndexedDB')) {
        (Get-ChildItem -Path (Join-Path $($env:APPDATA) '\Microsoft\teams\IndexedDB') -Recurse).Where{$_.Extension -eq '.db'} | Foreach-Object {
            $TotalKBToDelete += ($_.Length / 1024)
            $_ | Remove-Item -Recurse -Force
            Write-Verbose "Removed $($_.Name)"
        }
    }

    Start-Process -FilePath (Join-Path $env:LOCALAPPDATA '\Microsoft\Teams\Update.exe') -ArgumentList '-processStart "Teams.exe"'

    [void]([System.Windows.Forms.MessageBox]::Show("Cache cleared successfully. `nWe removed $($TotalKBToDelete / 1024)MB of cache data.","Information", "Ok" , "Information" , "Button1"))
}
