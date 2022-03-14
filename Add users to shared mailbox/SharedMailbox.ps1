#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 8, 2022         #
#           Version 1.0.1               #
#                                       #
#########################################
Connect-ExchangeOnline
$Users = Import-CSV $(Read-Host 'Please drag USERS file here') #Import CSV of Users
$Mailboxes = Import-CSV $(Read-Host 'Please drag MAILBOXES file here') #Import CSV of Mailboxes
foreach ($user in $users) {
    #Add each user to every mailbox
    foreach ($Mailbox in $Mailboxes) {
        Add-MailboxPermission -Identity $Mailbox.mailbox -User $User.user -AccessRights FullAccess -Confirm:$false
        Add-RecipientPermission -Identity $Mailbox.mailbox -Trustee $User.user -AccessRights SendAs -confirm:$false
    }
}