Function New-Migration {
    [cmdletbinding()]
    Param(
        [parameter(Mandatory=$true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] #No value
        [int]$pbi,
        [parameter(Mandatory=$true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] #No value
        [string]$database        
    )
    Begin {
        
        <#
            Helper function to show usage of cmdlet.
        #>
        Function Show-Usage {
        
            Show-InfoMessage "Usage: New-Migration -pbi [pbi] -database [database]"  
            Show-InfoMessage "database: portal for MAX Portal Database"
            Show-InfoMessage "database: pricing for MAX Pricing Database"
        }
    }
    Process {
        
        $workingDir = (Get-Item -Path ".\" -Verbose).FullName
        $sourceRootDir = "C:\Workspaces\Code\Dev"
        $databaseToMigrate = "";

        switch($database)
        {
            "portal"
                {                     
                    $databaseToMigrate = "MaxPortal"
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

        $rakeCommand = "bundle exec rake ""db:" + $database.ToString() + ":new_migration[Pbi" + $pbi.ToString() + ", 'Migration script for PBI " + $pbi.ToString() + "']""";

        cd $sourceRootDir

        Invoke-Expression -Command:$rakeCommand
        
        cd $workingDir
    }
}