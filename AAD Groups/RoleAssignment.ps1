#########################################
#                                       #
#       Author: Matthew Cantrell        #
#           Date: March 7, 2022         #
#           Version 1.0.6               #
#                                       #
#########################################

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