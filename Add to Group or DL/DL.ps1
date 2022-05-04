#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 24, 2022        #
#           Version 1.0.0               #
#                                       #
#########################################

$users = import-csv -path "C:\Users\Matthew\Documents\Powershell\Add to Group or DL\members.csv"
$owners = import-csv -path "C:\Users\Matthew\Documents\Powershell\Add to Group or DL\owners.csv"
$groups = import-csv -path "C:\Users\Matthew\Documents\Powershell\Add to Group or DL\groups.csv"

$members = Get-MsolUser -UserPrincipalName $user.user

foreach ($user in $users) {
	foreach ($group in $groups) {
		Add-MsolGroupMember -Identity $group.group -Member $members.userprincipalname -GroupMemberType User
	}
}