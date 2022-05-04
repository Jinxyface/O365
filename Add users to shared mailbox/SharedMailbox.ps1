#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 8, 2022         #
#           Version 1.0.1               #
#                                       #
#########################################

Connect-ExchangeOnline

function Show-Menu {
    param (
        [string]$Title = 'Shared Mailboxes'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "Press '1' to add members to a shared mailbox"
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
            $Users = Import-CSV $(Read-Host 'Please drag USERS file here') #Import CSV of Users via upn
            $Mailboxes = Import-CSV $(Read-Host 'Please drag MAILBOXES file here') #Import CSV of Mailboxes via upn
            foreach ($user in $users) {
                #Add each user to every mailbox
                foreach ($Mailbox in $Mailboxes) {
                    Add-MailboxPermission -Identity $Mailbox.mailbox -User $User.user -AccessRights FullAccess -Confirm:$false
                    Add-RecipientPermission -Identity $Mailbox.mailbox -Trustee $User.user -AccessRights SendAs -confirm:$false
                }
            }
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