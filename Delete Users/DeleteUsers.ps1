#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 14, 2022        #
#           Version 1.0.5               #
#                                       #
#########################################
Connect-MsolService
Connect-ExchangeOnline

function Show-Menu {
    param (
        [string]$Title = 'Delete Users'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "Press '1' to delete/block users"
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
			$Users = Import-CSV $(read-host 'Please drag and drop the CSV file here')

# CSV has two columns with a header: delete, and block. Takes UPNs

if (!$Users) {
	Write-Host 'No data in users.csv' -foregroundcolor "red"
}

foreach ($User in $Users) {
	if ($user.delete) {
		$DeleteUser = Get-MsolUser -UserPrincipalName $User.delete -ErrorAction SilentlyContinue
		$LitigationMailbox = Get-Mailbox -Identity $user.delete | where LitigationHoldEnabled -eq 'true'
		if ($DeleteUser) {
			if ($DeleteUser.displayname -match '\[T]') {
				Write-Host $DeleteUser.Displayname 'was not deleted, as their display name matches a pattern to skip'
			}
			if ($LitigationMailbox){
				White-Host $LitigationMailbox 'was not deleted, as they are on litigation hold'
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
