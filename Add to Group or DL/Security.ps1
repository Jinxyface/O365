#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 24, 2022        #
#           Version 1.0.0               #
#                                       #
#########################################

Import-CSV -path "C:\Users\Matthew\Documents\O365\Add to Group or DL\members.csv" | ForEach-Object {

	$UPN = $_.UserPrincipalName
	$Users = Get-MsolUser -UserPrincipalName $UPN
	$GroupID = Get-MsolGroup -ObjectId <ObjectID>
	
	$Users | ForEach-Object { Add-MsolGroupMember -GroupObjectId $GroupID.ObjectID -GroupMemberObjectId $Users.ObjectID -GroupMemberType User
	}
}