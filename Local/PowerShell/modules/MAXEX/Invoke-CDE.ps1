Function Invoke-CDE {
    [cmdletbinding()]
    Param(
        [parameter(Mandatory=$true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] #No value
        [int]$loanId,
        [parameter(Mandatory=$true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] #No value
        [string]$option
    )
    Begin {
        
        <#
            Helper function to show usage of cmdlet.
        #>
        Function Show-Usage {
        
            write-host "Usage: Invoke-CDE -loanId [loanId] -option [option]"
            write-host "option: d for Document Processing"
            write-host "option: mcd for Missing Core Documents"
            write-host "option: r for Receipt"
            write-host "option: ca for Corrupt Archive"            
        }

        <#
            Helper function to show information message.
        #>
        Function Show-Info-Message($msg)
        {
            Write-Host $msg -ForegroundColor White
        }
        
        <#
            Creates the compressed archive containing the result/manifest file and
            optional PDF files. This archive is then processed by the CDE service.
        #>
        Function Create-CDE-File($templateFileName, $loanId, $resultFileName, $workingDirName, $pdfDirName, $zipFileName, $dropDirName)
        {
            # Create staging directory.
            $stagingDirName = $workingDirName + "\Stage_" + $loanId.ToString();
            New-Item $stagingDirName -type directory

            # Create the result XML file from the template.
            Create-Response-File $stagingDirName $templateFileName $resultFileName $loanId

            # If the PDF directory was specified, copy PDFs to the staging directory.
            if($pdfDirName)
            {
                Copy-Item ($pdfDirName + "\*.*") $stagingDirName -Recurse
            }

            # Create the zip Archive with the result/manifest file and optional PDF documents in the staging directory.
            Create-Zip-File $stagingDirName $zipFileName

            # Copy archive to drop directory for processing.
            Show-Info-Message ("Copying zip file: " + $zipFileName + " to CDE processing directory: " + $dropDirName)
            Copy-Item $zipFileName -Destination $dropDirName

            # Cleanup temporary files.
            Show-Info-Message "Cleaning up temporary files" 
            Remove-Item $zipFileName
            Remove-Item $stagingDirName -Recurse
        }

        <#
            Creates the result/manifiest file from a given template.
        #>
        Function Create-Response-File($stagingDirName, $templateFileName, $resultFileName, $loanId)
        {
            $resultFileNameStaging = $stagingDirName + "\" + $resultFileName

            Show-Info-Message ("Creating response file: " + $resultFileNameStaging + " with template file: " + $templateFileName)

            Copy-Item $templateFileName -Destination ($resultFileNameStaging)
                        
            (Get-Content ($resultFileNameStaging)).Replace("LOAN_ID", $loanId.ToString()) | Set-Content $resultFileNameStaging
        }

        <#
            Creates ZIP Archive to be processed by CDE Service.
        #>
        Function Create-Zip-File($stagingDirName, $zipFileName)
        {           
            Show-Info-Message ("Creating zip archive: " + $zipFileName + " in staging directory: " + $stagingDirName)

            [System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')
            [System.Type]$typeAcceleratorsType=[System.Management.Automation.PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators',$true,$true)
            $typeAcceleratorsType::Add('zip','System.IO.Compression.Zipfile')


            [zip]::CreateFromDirectory($stagingDirName, $zipFileName)            
        }

        <#
            Helper function to launch the CDE Service Executable.
        #>
        Function Launch-CDE-Service($cdeServiceDirName, $cdeServiceExeName)
        {
            Show-Info-Message "Launching CDE Service"

            & ($cdeServiceDirName + "\" + $cdeServiceExeName)
        }
    }    
    Process {
        
        $templateFileName = ""

        $workingDirName = "C:\tools\bin\TestCDE"
        $zipFileName = $workingDirName + "\" + $loanId.ToString() + ".zip"
        $resultFileName = $loanId.ToString() + "_results.xml"
        $pdfDirName = $workingDirName + "\PDF"
        $dropDirName = "C:\ProcessedDocuments\Drop"
        $cdeServiceDirName = "C:\Workspaces\Code\Dev\Tools\Max.DocumentProcessingManager\bin\Debug"
        $cdeServiceExeName = "Max.DocumentProcessingManager.exe"

        switch($option)
        {
            "d"
                {                     
                    Show-Info-Message "Processing Documents"
                    $templateFileName = $workingDirName + "\" + "ProcessDocsTemplate.xml"
                    Create-CDE-File $templateFileName $loanId $resultFileName $workingDirName $pdfDirName $zipFileName $dropDirName                   
                    break                    
                }

            "mcd"
                {
                    Show-Info-Message "Processing Missing Core Documents"
                    $templateFileName = $workingDirName + "\" + "MissingCoreDocsTemplate.xml"
                    Create-CDE-File $templateFileName $loanId $resultFileName $workingDirName $null $zipFileName $dropDirName
                    break
                }
            "r"
                {
                    Show-Info-Message "Processing Receipt"
                    $templateFileName = $workingDirName + "\" + "ReceiptTemplate.xml"
                    Create-CDE-File $templateFileName $loanId $resultFileName $workingDirName $null $zipFileName $dropDirName
                    break
                }
            "ca"
                {
                    Show-Info-Message "Processing Corrupt Archive"
                    $templateFileName = $workingDirName + "\" + "CorruptArchiveTemplate.xml"
                    Create-CDE-File $templateFileName $loanId $resultFileName $workingDirName $null $zipFileName $dropDirName
                    break
                }

            default {
                Show-Info-Message "Invalid Option"
                Show-Usage
                return
            }
        }

        Launch-CDE-Service $cdeServiceDirName $cdeServiceExeName
    }        
}

#export-modulemember -function Invoke-CDE