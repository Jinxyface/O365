#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: May 2, 2022           #
#           Version 1.0.0               #
#                                       #
#########################################

#Input CSV for option 2 has one column that accepts UPNs

$Users = Import-CSV $(read-host 'Please drag and drop the CSV file here')
$Results = foreach($user in $users){
    Get-MailboxStatistics -Identity $user.upn
}
$Results | Export-CSV ./"MailboxSize_$((Get-Date).ToString("yyyyMMdd_HHmmss")).csv" -NoTypeInformation