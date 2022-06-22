#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: May 2, 2022           #
#           Version 1.0.0               #
#                                       #
#########################################

#input file is one column with the header "mailboxes" that takes mailbox upns

$Mailboxes = Import-csv $(Read-Host 'Please drag the input file here') 

$Results = foreach($mailbox in $mailboxes){
    Get-MailboxPermission -Identity $mailbox.mailbox
}

$Results | export-csv ./output.csv