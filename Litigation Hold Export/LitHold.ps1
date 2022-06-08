#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: June 8th, 2022        #
#           Version 1.0.0               #
#                                       #
#########################################

#Script will sccrape tenant wand export with a Litigation Hold boolean set to TRUE

Connect-ExchangeOnline

$Users = Get-Mailbox -ResultSize Unlimited | where LitigationHoldEnabled -eq 'true' | select Name,Displayname,UserPrincipalName,LitigationHoldenabled | export-csv ./"LitigationHold_$((Get-Date).ToString("yyyyMMdd_HHmmss")).csv" -NoTypeInformation