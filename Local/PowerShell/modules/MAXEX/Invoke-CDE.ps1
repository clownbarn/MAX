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
        
            Show-InfoMessage "Usage: Invoke-CDE -loanId [loanId] -option [option]"
            Show-InfoMessage "option: d for Document Processing"
            Show-InfoMessage "option: mcd for Missing Core Documents"
            Show-InfoMessage "option: r for Receipt"
            Show-InfoMessage "option: ca for Corrupt Archive"            
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
            Show-InfoMessage ("Copying zip file: " + $zipFileName + " to CDE processing directory: " + $dropDirName)
            Copy-Item $zipFileName -Destination $dropDirName

            # Cleanup temporary files.
            Show-InfoMessage "Cleaning up temporary files" 
            Remove-Item $zipFileName
            Remove-Item $stagingDirName -Recurse
        }

        <#
            Creates the result/manifiest file from a given template.
        #>
        Function Create-Response-File($stagingDirName, $templateFileName, $resultFileName, $loanId)
        {
            $resultFileNameStaging = $stagingDirName + "\" + $resultFileName

            Show-InfoMessage ("Creating response file: " + $resultFileNameStaging + " with template file: " + $templateFileName)

            Copy-Item $templateFileName -Destination ($resultFileNameStaging)
                        
            (Get-Content ($resultFileNameStaging)).Replace("LOAN_ID", $loanId.ToString()) | Set-Content $resultFileNameStaging
        }

        <#
            Creates ZIP Archive to be processed by CDE Service.
        #>
        Function Create-Zip-File($stagingDirName, $zipFileName)
        {           
            Show-InfoMessage ("Creating zip archive: " + $zipFileName + " in staging directory: " + $stagingDirName)

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
            Show-InfoMessage "Launching CDE Service"

            & ($cdeServiceDirName + "\" + $cdeServiceExeName)
        }
    }    
    Process {
        
        $templateFileName = ""

        $workingDirName = "C:\tools\bin\MAX\TestCDE"
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
                    Show-InfoMessage "Processing Documents"
                    $templateFileName = $workingDirName + "\" + "ProcessDocsTemplate.xml"
                    Create-CDE-File $templateFileName $loanId $resultFileName $workingDirName $pdfDirName $zipFileName $dropDirName                   
                    break                    
                }

            "mcd"
                {
                    Show-InfoMessage "Processing Missing Core Documents"
                    $templateFileName = $workingDirName + "\" + "MissingCoreDocsTemplate.xml"
                    Create-CDE-File $templateFileName $loanId $resultFileName $workingDirName $null $zipFileName $dropDirName
                    break
                }
            "r"
                {
                    Show-InfoMessage "Processing Receipt"
                    $templateFileName = $workingDirName + "\" + "ReceiptTemplate.xml"
                    Create-CDE-File $templateFileName $loanId $resultFileName $workingDirName $null $zipFileName $dropDirName
                    break
                }
            "ca"
                {
                    Show-InfoMessage "Processing Corrupt Archive"
                    $templateFileName = $workingDirName + "\" + "CorruptArchiveTemplate.xml"
                    Create-CDE-File $templateFileName $loanId $resultFileName $workingDirName $null $zipFileName $dropDirName
                    break
                }

            default {
                Show-InfoMessage "Invalid Option"
                Show-Usage
                return
            }
        }

        Launch-CDE-Service $cdeServiceDirName $cdeServiceExeName
    }        
}

#export-modulemember -function Invoke-CDE