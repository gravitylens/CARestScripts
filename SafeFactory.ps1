Import-Module ./wrapper.psm1
Import-Module ./GroupFactory.psm1

#Added for Securing RestAPI Scripts exercise
Import-Module CredentialRetriever

#Users may use passwords, view logs and Initiate CPM Operations
$usersafeperms = @(
    @{"Key"="UseAccounts"; "Value"=$true},
    @{"Key"="RetrieveAccounts"; "Value"=$true},
    @{"Key"="ListAccounts"; "Value"=$true},
    @{"Key"="AddAccounts"; "Value"=$false},
    @{"Key"="InitiateCPMAccountManagementOperations"; "Value"=$true},
    @{"Key"="ViewAuditLog"; "Value"=$true},
    @{"Key"="ViewSafeMembers"; "Value"=$true}
)

#Auditors may list accounts and view logs
$auditorsafeperms = @(
    @{"Key"="UseAccounts"; "Value"=$false},
    @{"Key"="RetrieveAccounts"; "Value"=$false},
    @{"Key"="ListAccounts"; "Value"=$true},
    @{"Key"="ViewAuditLog"; "Value"=$true},
    @{"Key"="ViewSafeMembers"; "Value"=$true}
)

#Manager permissions are the same as the auditors with the addition of approving requests
$managersafeperms = $auditorsafeperms + @{"Key"="RequestsAuthorizationLevel"; "Value"=1}

#Vault Admins have Operations, Audit, and Advanced Permissions
$vaultadminsafeperms = @(
    @{"Key"="UseAccounts"; "Value"=$false},
    @{"Key"="RetrieveAccounts"; "Value"=$false},
    @{"Key"="ListAccounts"; "Value"=$true},
    @{"Key"="AddAccounts"; "Value"=$true},
    @{"Key"="UpdateAccountContent"; "Value"=$true},
    @{"Key"="UpdateAccountProperties"; "Value"=$true},
    @{"Key"="InitiateCPMAccountManagementOperations"; "Value"=$true},
    @{"Key"="RenameAccounts"; "Value"=$true},
    @{"Key"="DeleteAccounts"; "Value"=$true},
    @{"Key"="UnlockAccounts"; "Value"=$true},
    @{"Key"="ManageSafe"; "Value"=$true},
    @{"Key"="ManageSafeMembers"; "Value"=$true},
    @{"Key"="ViewAuditLog"; "Value"=$true},
    @{"Key"="ViewSafeMembers"; "Value"=$true},
    @{"Key"="CreateFolders"; "Value"=$true},
    @{"Key"="DeleteFolders"; "Value"=$true},
    @{"Key"="MoveAccountsAndFolders"; "Value"=$true}
)

#On the Recording safes Auditors have typical end user permissions
$auditorrecsafeperms = $usersafeperms

#Managers are the same as auditors
$managerrecsafeperms = $usersafeperms

#The PSMMaster group must have all permissions on recordings safes
$psmrecsafeperms=@(
    @{"Key"="UseAccounts"; "Value"=$true},
    @{"Key"="RetrieveAccounts"; "Value"=$true},
    @{"Key"="ListAccounts"; "Value"=$true},
    @{"Key"="AddAccounts"; "Value"=$true},
    @{"Key"="UpdateAccountContent"; "Value"=$true},
    @{"Key"="UpdateAccountProperties"; "Value"=$true},
    @{"Key"="InitiateCPMAccountManagementOperations"; "Value"=$true},
    @{"Key"="SpecifyNextAccountContent"; "Value"=$true},
    @{"Key"="RenameAccounts"; "Value"=$true},
    @{"Key"="DeleteAccounts"; "Value"=$true},
    @{"Key"="UnlockAccounts"; "Value"=$true},
    @{"Key"="ManageSafe"; "Value"=$true},
    @{"Key"="ManageSafeMembers"; "Value"=$true},
    @{"Key"="BackupSafe"; "Value"=$true},
    @{"Key"="ViewAuditLog"; "Value"=$true},
    @{"Key"="ViewSafeMembers"; "Value"=$true},
    @{"Key"="RequestsAuthorizationLevel"; "Value"=1},
    @{"Key"="AccessWithoutConfirmation"; "Value"=$true},
    @{"Key"="CreateFolders"; "Value"=$true},
    @{"Key"="DeleteFolders"; "Value"=$true},
    @{"Key"="MoveAccountsAndFolders"; "Value"=$true}
)

#Retrieve the Administrator password from the Vault and Start a new session.
$(Get-CCPCredential -AppID App-PVWA-API -Safe CyberArk-Admin -Username Administrator -URL $url).ToCredential() | New-CASession
#Get-Credential | New-CASession

Import-csv ./test.csv | ForEach-Object{
    $SafeName = $_.SafeName
    $UsersGroup = "CyberArk_$($SafeName)_Users"
    $ManagersGroup = "CyberArk_$($SafeName)_Managers"
    $AuditorsGroup = "CyberArk_$($SafeName)_Auditors"
    
    write-host "Creating $SafeName"
    
    #Create Safes
    New-CASafe $SafeName
    New-CASafe "Rec_$SafeName"
    
    #Add Vault Admins to Safes
    New-CASafeMember -SafeName $SafeName -MemberName "Vault Admins" -SearchIn "Vault" -Permissions $vaultadminsafeperms
    New-CASafeMember -SafeName "Rec_$SafeName" -MemberName "Vault Admins" -SearchIn "Vault" -Permissions $vaultadminsafeperms
    
    #Add Users to Safes
    New-CAADGroup $UsersGroup
    New-CASafeMember -SafeName $SafeName -MemberName $UsersGroup -SearchIn "cyber-ark-demo.local" -Permissions $usersafeperms

    #Add Managers to Safes
    New-CAADGroup $ManagersGroup
    New-CASafeMember -SafeName $SafeName -MemberName $ManagersGroup -SearchIn "cyber-ark-demo.local" -Permissions $managersafeperms
    New-CASafeMember -SafeName "Rec_$SafeName" -MemberName $ManagersGroup -SearchIn "cyber-ark-demo.local" -Permissions $managerrecsafeperms

    #Add Auditors to Safes
    New-CAADGroup $AuditorsGroup
    New-CASafeMember -SafeName $SafeName -MemberName $AuditorsGroup -SearchIn "cyber-ark-demo.local" -Permissions $auditorsafeperms
    New-CASafeMember -SafeName "Rec_$SafeName" -MemberName $AuditorsGroup -SearchIn "cyber-ark-demo.local" -Permissions $auditorrecsafeperms
    
    #Add PSMMaster to Safes
    New-CASafeMember -SafeName "Rec_$SafeName" -MemberName "PSMMaster" -SearchIn "Vault" -Permissions $psmrecsafeperms
}