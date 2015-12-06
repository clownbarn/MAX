Function Invoke-DBBackup {
    
    [cmdletbinding()]
        Param(
            [parameter(Mandatory=$true, ValueFromPipeline)]
            [ValidateNotNullOrEmpty()] #No value
            [string]$database
            )
            
	Begin {
        
        <#
            Helper function to show usage of cmdlet.
        #>
        Function Show-Usage {
        
            write-host "Usage: Invoke-DBBackup -database [db]"
            write-host "db: portal for MAX Portal Database"
            write-host "db: pricing for MAX Pricing Database"
        }

        <#
            Helper function to show information message.
        #>
        Function Show-Info-Message($msg)
        {
            Write-Host $msg -ForegroundColor White
        }

	}
	Process {
        
        $workingDir = (Get-Item -Path ".\" -Verbose).FullName
        $databaseToBackup = "";

        switch($database)
        {
            "portal"
                {                     
                    $databaseToBackup = "MaxPortal"
                    break                    
                }

            "pricing"
                {                    
                    $databaseToBackup = "MaxPricing"
                    break
                }
            
            default {
                Show-Info-Message "Invalid Database"
                Show-Usage
                return
            }
        }

        Show-Info-Message ("Backing Up " + $databaseToBackup + " Database...")

        Add-Type -path "C:\Windows\assembly\GAC_MSIL\Microsoft.SqlServer.Smo\10.0.0.0__89845dcd8080cc91\Microsoft.SqlServer.Smo.dll"
		$sqlServer = New-Object 'Microsoft.SqlServer.Management.SMO.Server' $inst
        $sqlServerName = $sqlServer.Name
        $backupdir = $sqlServer.Settings.BackupDirectory
        $currentDateTime = get-date -format yyyyMMddHHmmss
        $backupFileName = "$backupdir\$($databaseToBackup)_db_$($currentDateTime).bak"

        Backup-SqlDatabase -ServerInstance $sqlServerName -Database $databaseToBackup -BackupFile $backupFileName

        Show-Info-Message ($databaseToBackup + " Database Back Up Complete.")

        cd $workingDir        
	}
}

#export-modulemember -function Invoke-DBBackup