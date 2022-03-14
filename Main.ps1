#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 7, 2022         #
#           Version 1.0.1               #
#                                       #
#########################################

function Show-Menu {
    param (
        [string]$Title = 'Main Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "Press '1' to export members of enterprise apps"
    Write-Host "Press '2' to delete users"
    Write-Host "Press '3' to query group owners/members"
    Write-Host "Press '4' to add users to shared mailboxes"
    Write-Host "Press 'q' to quit"
}
do {
    Show-Menu
    if ($Message) {
        Write-Host "========================" -ForegroundColor $color
        Write-Host $Message -ForegroundColor $color
        Write-Host "========================" -ForegroundColor $color
    }
    $selection = Read-Host "Please make a selection"
    switch ($selection) {
        '1' {
            & '.\Enterprise App Members\EntAppMembers.ps1'
        } '2' {
            & '.\Delete Users\DeleteUsers.ps1'
        }  '3' {
            & '.\AAD Groups\RoleAssignment.ps1'
        } '4' {
            & 'Add users to shared mailbox\SharedMailbox.ps1'
        } 'q' {
            return
            break
        }
        default {
            $Message = "Invalid option, please try again"
            $color = "red"
        }
    }
}
until ($selection -eq 'q')