#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 7, 2022         #
#           Version 1.0.3               #
#                                       #
#########################################

try {
    Get-AzureADTenantDetail
}
catch [Microsoft.Open.Azure.AD.CommonLibrary.AadNeedAuthenticationException] {
    Write-Host "You're not connected, please sign in."
    Connect-AzureAD
}
function Show-Menu {
    param (
        [string]$Title = 'Enterprise App Users'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "Press '1' to query the members of one App"
    Write-Host "Press '2' to query the members of multiple Apps"
    Write-Host "Press 'r' to return to main menu"
}
function Get-AppMembers([Object]$ObjectID) {
    $App = Get-AzureADServicePrincipal -ObjectID $ObjectID
    $Results = Get-AzureADServiceAppRoleAssignment -ObjectID $App.ObjectId
    $Members = foreach ($Result in $Results) {
        if ($Result.principaltype -eq 'user') {
            get-azureaduser -ObjectID $Result.principalID
        }
        if ($Result.principaltype -eq 'group') {
            Get-AzureADGroupMember -ObjectID $Result.principalID       
        }
    }
    $Members | foreach-object {
        [PSCustomObject]@{
            "User Display Name"  = $_.DisplayName
            UPN                  = $_.UserPrincipalName
            "User Object ID"     = $_.ObjectID
            Application          = $App.Displayname
            "App Object ID"      = $App.ObjectID
            "Application App ID" = $App.AppID
        }
    }	
}
$Color = "white"
$Message = "";
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
            $Group = Read-Host -Prompt "Please input the Object ID of Enterprise App"
            $Output = Get-AppMembers($Group)
            $Output | export-csv ./Output.csv -NoTypeInformation
            $Message = "Task completed"
            $Color = "green"
            Break
        }
        '2' {
            $Groups = Import-CSV $(read-host 'Please drag and drop the CSV file here')
            $Output = foreach ($Group in $Groups) {
                Get-AppMembers($Group.group)
            }
            $Output | export-csv ./EntAppMembersOutput.csv -NoTypeInformation
            $Message = "Task completed"
            $Color = "green"
            Break
        }  'r' {
            & ".\Controller.ps1"
        }
        default {
            $Message = "Invalid option, please try again"
            $Color = "red"
        }
    }
}
until ($Selection -eq 'r')