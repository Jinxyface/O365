Import-CSV -path "C:\Users\Matthew\Documents\Powershell\Add to Group or DL\members.csv" | ForEach {

	$UPN=$_.UserPrincipalName
	$Users=Get-MsolUser -UserPrincipalName $UPN
	$Groupid = Get-MsolGroup -ObjectId <objectID>
	
	$Users | ForEach {Add-MsolGroupMember -GroupObjectId $GroupID.ObjectID -GroupMemberObjectId $Users.ObjectID -GroupMemberType User
		}
	}