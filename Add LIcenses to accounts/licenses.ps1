<# To add license, use -AddLicense #>
<# To remove license, use -RemoveLicense #>
<# To replace license, use -AddLicense and then -RemoveLicense at same time #>

$users=import-csv C:\Users\Matthew\Documents\users.csv
foreach ($user in $users){
Set-MsolUserLicense -UserPrincipalName $user.user -AddLicenses "vmsassociates:PBI_PREMIUM_PER_USER"
}

