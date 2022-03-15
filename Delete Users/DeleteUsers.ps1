#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 14, 2022        #
#           Version 1.0.5               #
#                                       #
#########################################


$Users = Import-CSV $(read-host 'Please drag and drop the CSV file here')

# CSV has two columns with a header: delete, and block. Takes UPNs

if (!$Users) {
	Write-Host 'No data in users.csv' -foregroundcolor "red"
}

foreach ($User in $Users) {
	if ($user.delete) {
		$DeleteUser = Get-MsolUser -UserPrincipalName $User.delete -ErrorAction SilentlyContinue
		if ($DeleteUser) {
			if ($DeleteUser.displayname -match '\[T]') {
				Write-Host $DeleteUser.Displayname 'was not deleted'
			}
			else {
				Remove-MsolUser -UserPrincipalName $DeleteUser.UserPrincipalName -Force
				Write-Host $DeleteUser.DisplayName 'had their account deleted'
			}
		}
		else {
			Write-Host 'Could not delete, ' $User.delete 'was not found' -foregroundcolor "red"
		}
	}

	if ($User.block) {
		$BlockUser = Get-MsolUser -UserPrincipalName $User.block -ErrorAction SilentlyContinue
		if ($BlockUser) {
			Set-MsolUser -UserPrincipalName $BlockUser.UserPrincipalName -BlockCredential $True
			Write-Host $BlockUser.Displayname 'had their sign in blocked'
		}
		else {
			Write-Host 'Could not block' $User.block '- user was not found' -foregroundcolor "red"
		}
	}
}
