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
    
    Write-Host "Press '1' to add members to AAD Groups"
    Write-Host "Press '2' to add to DLs/Security groups"
    Write-Host "Press '3' to add users to shared mailboxes"
    Write-Host "Press '4' to delete users"
    Write-Host "Press '5' to query members of enterprise apps"
    Write-Host "Press '6' to query last password change"
    Write-Host "Press '7' to manage account licenses"
    Write-Host "Press '8' to query mailbox size"
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
            & '.\AAD Groups\RoleAssignment.ps1'
        } '2' {
            & '.\Add to Group or DL\Groups.ps1'
        } '3' {
            & '.\Add users to shared mailbox\SharedMailbox.ps1'
        } '4' {
            & '.\Delete Users\DeleteUsers.ps1'
        } '5' {
            & '.\Enterprise App Members\EntAppMembers.ps1'
        } '6' {
            & '.\Last Password Change\LastPasswordChange.ps1'
        } '7' {
            & '.\Licenses\Licenses.ps1'
        } '8' {
            & '.\Mailbox Size\MailboxSize.ps1'
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