$Users = Import-CSV $(read-host 'Please drag and drop the CSV file here')

# CSV has two columns with a header: delete, and block. Takes UPNs

if (!$Users) {
	Write-Host 'No data in users.csv' -foregroundcolor "red"
}

foreach ($User in $Users) {
	if ($user.delete) {
		$DeleteUser = Get-AzureADUser -ObjectId $User.delete -ErrorAction SilentlyContinue
		if ($Null -ne $DeleteUser) {
			if ($DeleteUser.displayname -match '\[T]') {
				Write-Host $DeleteUser.Displayname 'was not deleted'
			}
			else {
				Remove-AzureADUser -ObjectId $user.delete -Force
				Write-Host $DeleteUser.DisplayName 'had their account deleted'
			}
		}
		else {
			Write-Host 'Could not delete, ' $User.delete 'was not found' -foregroundcolor "red"
		}
	}

	if ($User.block) {
		$BlockUser = Get-AzureADUser -ObjectID $User.block -ErrorAction SilentlyContinue
		if ($Null -ne $BlockUser) {
			Set-MsolUser -ObjectID $user.block -BlockCredential $True
			Write-Host $BlockUser.Displayname 'had their sign in blocked'
		}
		else {
			Write-Host 'Could not block' $User.block 'was not found' -foregroundcolor "red"
		}
	}
}
