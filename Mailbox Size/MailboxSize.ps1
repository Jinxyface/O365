#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: May 2, 2022           #
#           Version 1.0.0               #
#                                       #
#########################################

Connect-ExchangeOnline
function Show-Menu {
    param (
        [string]$Title = 'Mailbox Size'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "Press '1' to query mailbox sizes"
    Write-Host "Press 'r' to return to main menu"
}
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
            #Input CSV for option 2 has one column that accepts UPNs

            $Users = Import-CSV $(read-host 'Please drag and drop the CSV file here')
            $Results = foreach ($user in $users) {
                Get-MailboxStatistics -Identity $user.upn
            }
            $Results | Select Displayname,TotalItemSize |  Export-CSV ./"MailboxSize_$((Get-Date).ToString("yyyyMMdd_HHmmss")).csv" -NoTypeInformation
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