#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 14, 2022        #
#           Version 1.0.5               #
#                                       #
#########################################

#Input CSV has two headers, one for group names, and one for objectIDs

function Show-Menu {
    param (
        [string]$Title = 'Enterprise App Users'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "Press '1' to query the role assignment of one group"
    Write-Host "Press '2' to query the role assignment of multiple groups"
    Write-Host "Press 'r' to return to main menu"
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
            $Inputs = Read-Host 'Please paste the group object ID' #Import group via Object ID
            $Groups = Get-AzureADGroup -ObjectID $Inputs
            $OwnerResults = foreach ($Group in $Groups) {
                $gOwners = Get-AzureADGroupOwner -ObjectID $Group.ObjectID
                if ($gOwners) {
                    foreach ($gOwner in $gOwners) {
                        [PSCustomObject]@{ #Export groups that do have owners to array
                            Group             = $Group.DisplayName
                            "Group Object ID" = $Group.ObjectID
                            Owner             = $gOwner.DisplayName
                            "Owner UPN"       = $gOwner.UserPrincipalName
                            "Owner Object ID" = $gOwner.ObjectID
                        }
                    }
                }
                else {
                    [PSCustomObject]@{ #Export groups that do have owners to array
                        Group             = $Group.DisplayName
                        "Group Object ID" = $Group.ObjectID
                        Owner             = "No Owner in AAD"
                        "Owner UPN"       = "No Owner in AAD"
                        "Owner Object ID" = "No Owner in AAD"
                    }
                }
            }
            $MemberResults = foreach ($Group in $Groups) {
                $gMembers = Get-AzureADGroupMember -ObjectID $Group.ObjectID
                if ($gMembers) {
                    foreach ($gMember in $gMembers) {
                        [PSCustomObject]@{ #Export groups that do have members to array
                            Group              = $Group.DisplayName
                            "Group Object ID"  = $Group.ObjectID
                            Member             = $gMember.DisplayName
                            "Member UPN"       = $gMember.UserPrincipalName
                            "Member Object ID" = $gMember.ObjectID
                        }
                    }
                }
                else {
                    [PSCustomObject]@{ #Export groups that do have members to array
                        Group              = $Group.DisplayName
                        "Group Object ID"  = $Group.ObjectID
                        Member             = "No members in AAD"
                        "Member UPN"       = "No members in AAD"
                        "Member Object ID" = "No members in AAD"
                    }
                }
            }
            $OwnerResults | export-csv ./GroupOwners.csv -NoTypeInformation
            $MemberResults | export-csv ./GroupMembers.csv -NoTypeInformation
            $Message = "Task completed"
            $Color = "green"
        }
        '2' {
            $Inputs = Import-CSV $(Read-Host 'Please drag the input file here') #Import CSV file
            $Groups = foreach ($input in $inputs) {
                #Populate $Groups variable from Azure via ObjectID
                if ($input.object) {
                    Get-AzureADGroup -ObjectID $input.Object
                }
                #Populates $Groups variable from Azure via Display Name
                if ($input.DisplayName) {
                    $Filter = $input.DisplayName
                    Get-AzureADGroup -Filter "DisplayName eq '$Filter'"
                }
            }
            $OwnerResults = foreach ($Group in $Groups) {
                $gOwners = Get-AzureADGroupOwner -ObjectID $group.ObjectID
                if ($gOwners) {
                    foreach ($gOwner in $gOwners) {
                        [PSCustomObject]@{ #Export groups that do have owners to array
                            Group             = $Group.DisplayName
                            "Group Object ID" = $Group.ObjectID
                            Owner             = $gOwner.DisplayName
                            "Owner UPN"       = $gOwner.UserPrincipalName
                            "Owner Object ID" = $gOwner.ObjectID
                        }
                    }
                }
                else {
                    [PSCustomObject]@{ #Export groups that do have owners to array
                        Group             = $Group.DisplayName
                        "Group Object ID" = $Group.ObjectID
                        Owner             = "No Owner in AAD"
                        "Owner UPN"       = "No Owner in AAD"
                        "Owner Object ID" = "No Owner in AAD"
                    }
                }
            }
            $MemberResults = foreach ($Group in $Groups) {
                $gMembers = Get-AzureADGroupMember -ObjectID $group.ObjectID
                if ($gMembers) {
                    foreach ($gMember in $gMembers) {
                        [PSCustomObject]@{ #Export groups that do have members to array
                            Group              = $Group.DisplayName
                            "Group Object ID"  = $Group.ObjectID
                            Member             = $gMember.DisplayName
                            "Member UPN"       = $gMember.UserPrincipalName
                            "Member Object ID" = $gMember.ObjectID
                        }
                    }
                }
                else {
                    [PSCustomObject]@{ #Export groups that do have members to array
                        Group              = $Group.DisplayName
                        "Group Object ID"  = $Group.ObjectID
                        Member             = "No members in AAD"
                        "Member UPN"       = "No members in AAD"
                        "Member Object ID" = "No members in AAD"
                    }
                }
            }
            $OwnerResults | export-csv ./GroupOwners.csv -NoTypeInformation
            $MemberResults | export-csv ./GroupMembers.csv -NoTypeInformation
            $Message = "Task completed"
            $Color = "green"
        }  'r' {
            & ".\Main.ps1"
        }
        default {
            $Message = "Invalid option, please try again"
            $Color = "red"
        }
    }
}
until ($Selection -eq 'r')