#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 14, 2022        #
#           Version 1.0.5               #
#                                       #
#########################################

#input file has one header called "user" that accepts UPNs

$users=import-csv C:\Users\Matthew\Documents\users.csv
foreach ($user in $users){
Set-MsolUserLicense -UserPrincipalName $user.user -AddLicenses "vmsassociates:<SKUID>"
}

