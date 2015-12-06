Function Invoke-LoanStatus {
    
    Begin {
        
        <#
            Helper function to launch the Loan Status Service Executable.
        #>
        Function Launch-Loan-Status-Service($loanStatusServiceDirName, $loanStatusServiceExeName)
        {
            Show-InfoMessage "Launching Loan Status Service"

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