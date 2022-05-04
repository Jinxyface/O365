#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: April 10, 2022        #
#           Version 1.0.0               #
#                                       #
#########################################

#Input CSV for option 2 has one column that accepts UPNs
Connect-MsolService
function Show-Menu {
    param (
        [string]$Title = 'Last Password Change Date'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "Press '1' to query a single user"
    Write-Host "Press '2' to query multiple users"
    Write-Host "Press '3' to query the entire tenant"
    Write-Host "Press 'r' to return to main menu"
}
$Color = "white"
$Message = "";
do {
    Show-Menu
    if ($Message) {
        Write-Host "========================" -ForegroundColor $Color
        Write-Host $Message -ForegroundColor $Color
        Write-Host "========================" -ForegroundColor $Color
    }
    $Selection = Read-Host "Please make a selection"
    switch ($Selection) {
        '1' {
            $User = Get-MsolUser -UserPrincipalName $(Read-Host "Please type the UPN of the user")
            $User | Select DisplayName, UserPrincipalName, LastPasswordChangeTimeStamp | export-csv ./"LastPasswordChange_$((Get-Date).ToString("yyyyMMdd_HHmmss")).csv" -NoTypeInformation
            $Message = "Task completed"
            $Color = "green"
            Break
        } '2' {
            $Users = Import-CSV $(read-host 'Please drag and drop the CSV file here')
            $Results = foreach ($user in $users) {
                Get-MsolUser -UserPrincipalName $user.upn
            }
            $Results | Select DisplayName, UserPrincipalName, LastPasswordChangeTimeStamp | export-csv ./"LastPasswordChange_$((Get-Date).ToString("yyyyMMdd_HHmmss")).csv" -NoTypeInformation
            $Message = "Task completed"
            $Color = "green"
            Break
        }  '3' {
            $Users = Get-MsolUser -All
            $Users | Select DisplayName, UserPrincipalName, LastPasswordChangeTimeStamp | export-csv ./"LastPasswordChange_$((Get-Date).ToString("yyyyMMdd_HHmmss")).csv" -NoTypeInformation
            $Message = "Task completed"
            $Color = "green"
            Break
        } 'r' {
            & "..\Main.ps1"
        }
        default {
            $Message = "Invalid option, please try again"
            $Color = "red"
        }
    }
}
until ($Selection -eq 'r')