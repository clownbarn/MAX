Function Invoke-LoanStatus {
    
    Begin {
        <#
            Helper function to show information message.
        #>
        Function Show-Info-Message($msg)
        {
            Write-Host $msg -ForegroundColor White
        }

        <#
            Helper function to launch the Loan Status Service Executable.
        #>
        Function Launch-Loan-Status-Service($loanStatusServiceDirName, $loanStatusServiceExeName)
        {
            Show-Info-Message "Launching Loan Status Service"

            & ($loanStatusServiceDirName + "\" + $loanStatusServiceExeName)
        }
    }
    Process {
        
        $loanStatusServiceDirName = "C:\Workspaces\Code\Dev\Tools\Max.LoanStatusService\bin\Debug"
        $loanStatusServiceExeName = "Max.LoanStatusService.exe"
        
        Launch-Loan-Status-Service $loanStatusServiceDirName $loanStatusServiceExeName
    }
}

#export-modulemember -function Invoke-LoanStatus