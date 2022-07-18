#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 24, 2022        #
#           Version 1.0.0               #
#                                       #
#########################################
Connect-MsolService
Connect-ExchangeOnline
Start-Transcript -OutputDirectory ./
function Show-Menu {
	param (
		[string]$Title = 'Groups'
	)
	Clear-Host
	Write-Host "================ $Title ================"
    
	Write-Host "Press '1' to add members to a DL"
	Write-Host "Press '2' to add members to an MSOL Group"
	Write-Host "Press '3' to add members to a security group"
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
			$Users = Import-CSV $(Read-Host 'Please drag the users input file here') #Import CSV file
			$Group = Get-DistributionGroup -Identity $(Read-Host "Please type the SMTP address of the distribution group")
			foreach ($user in $users) {
				$DistUsers = Get-Mailbox -Identity $user.user
				foreach ($DistUser in $DistUsers) {
					Add-DistributionGroupMember -Identity $Group.PrimarySMTPAddress -Member $DistUser.PrimarySMTPAddress
				}
			}
		} '2' {
			$users = Import-CSV $(Read-Host 'Please drag the users input file here') #Import CSV file
			$groups = Import-CSV $(Read-Host 'Please drag the groups input file here') #Import CSV file
			$members = Get-MsolUser -UserPrincipalName $user.user
			foreach ($user in $users) {
				foreach ($group in $groups) {
					Add-MsolGroupMember -Identity $group.group -Member $members.userprincipalname -GroupMemberType User
				}
			}
		} '3' {
			Import-CSV $(Read-Host 'Please drag the input file here') | ForEach-Object {
			$UPN = $_.UserPrincipalName
			$Users = Get-MsolUser -UserPrincipalName $UPN
			$GroupID = Get-MsolGroup -ObjectId $(Read-Host "Please paste the ObjectID of the group")
			$Users | ForEach-Object { Add-MsolGroupMember -GroupObjectId $GroupID.ObjectID -GroupMemberObjectId $Users.ObjectID -GroupMemberType User
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