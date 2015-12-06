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
        
            Show-InfoMessage "Usage: Invoke-DBBackup -database [db]"
            Show-InfoMessage "db: portal for MAX Portal Database"
            Show-InfoMessage "db: pricing for MAX Pricing Database"
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
                Show-InfoMessage "Invalid Database"
                Show-Usage
                return
            }
        }

        Show-InfoMessage ("Backing Up " + $databaseToBackup + " Database...")

        Add-Type -path "C:\Windows\assembly\GAC_MSIL\Microsoft.SqlServer.Smo\10.0.0.0__89845dcd8080cc91\Microsoft.SqlServer.Smo.dll"

		$sqlServer = New-Object 'Microsoft.SqlServer.Management.SMO.Server' $inst
        $sqlServerName = $sqlServer.Name
        $backupdir = $sqlServer.Settings.BackupDirectory
        $currentDateTime = get-date -format yyyyMMddHHmmss
        $backupFileName = "$backupdir\$($databaseToBackup)_db_$($currentDateTime).bak"

        Backup-SqlDatabase -ServerInstance $sqlServerName -Database $databaseToBackup -BackupFile $backupFileName

        Show-InfoMessage ($databaseToBackup + " Database Back Up Complete.")

        cd $workingDir        
	}
}

#export-modulemember -function Invoke-DBBackup