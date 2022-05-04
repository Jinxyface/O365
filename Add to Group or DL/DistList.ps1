#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 24, 2022        #
#           Version 1.0.0               #
#                                       #
#########################################

#Input CSV has one header called "upn"

$Users = Import-CSV ./Members.csv
$Group = Get-DistributionGroup -Identity $(Read-Host "Please type the SMTP address of the distribution group")
foreach($user in $users){
    $DistUsers = Get-Mailbox -Identity $user.user
    foreach($DistUser in $DistUsers){
        Add-DistributionGroupMember -Identity $Group.PrimarySMTPAddress -Member $DistUser.Alias
    }
}