<#
Copyright [2020] [CyberArk Software, Inc.]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>
Import-Module ./wrapper.psm1
Import-Module ./GroupFactory.psm1

#Added for Securing RestAPI Scripts exercise
Import-Module CredentialRetriever

#Users may use passwords, view logs and Initiate CPM Operations
$usersafeperms =@{
    "useAccounts"=$true;
    "retrieveAccounts"=$true;
    "listAccounts"=$true;
    "addAccounts"=$true;
    "initiateCPMAccountManagementOperations"=$true;
    "viewAuditLog"=$true;
    "viewSafeMembers"=$true;
}
#Auditors may list accounts and view logs
$auditorsafeperms =@{
    "useAccounts"=$false;
    "retrieveAccounts"=$false;
    "listAccounts"=$true;
    "viewAuditLog"=$true;
    "viewSafeMembers"=$true
}

#Manager permissions are the same as the auditors with the addition of approving requests
$managersafeperms =@{
    "useAccounts"=$false;
    "retrieveAccounts"=$false;
    "listAccounts"=$true;
    "viewAuditLog"=$true;
    "viewSafeMembers"=$true;
    "requestsAuthorizationLevel1"=$true
}

#Vault Admins have Operations, Audit, and Advanced Permissions
$vaultadminsafeperms =@{
    "useAccounts"=$false;
    "retrieveAccounts"=$false;
    "listAccounts"=$true;
    "addAccounts"=$true;
    "updateAccountContent"=$true;
    "updateAccountProperties"=$true;
    "initiateCPMAccountManagementOperations"=$true;
    "renameAccounts"=$true;
    "deleteAccounts"=$true;
    "unlockAccounts"=$true;
    "manageSafe"=$true;
    "manageSafeMembers"=$true;
    "viewAuditLog"=$true;
    "viewSafeMembers"=$true;
    "createFolders"=$true;
    "deleteFolders"=$true;
    "moveAccountsAndFolders"=$true
}


#On the Recording safes Auditors have typical end user permissions
$auditorrecsafeperms = $usersafeperms

#Managers are the same as auditors
$managerrecsafeperms = $usersafeperms

#The PSMMaster group must have all permissions on recordings safes
$psmrecsafeperms=@{
    "useAccounts"=$true;
    "retrieveAccounts"=$true;
    "listAccounts"=$true;
    "addAccounts"=$true;
    "updateAccountContent"=$true;
    "updateAccountProperties"=$true;
    "initiateCPMAccountManagementOperations"=$true;
    "specifyNextAccountContent"=$true;
    "renameAccounts"=$true;
    "deleteAccounts"=$true;
    "unlockAccounts"=$true;
    "manageSafe"=$true;
    "manageSafeMembers"=$true;
    "backupSafe"=$true;
    "viewAuditLog"=$true;
    "viewSafeMembers"=$true;
    "accessWithoutConfirmation"=$true;
    "createFolders"=$true;
    "deleteFolders"=$true;
    "moveAccountsAndFolders"=$true
}


#Retrieve the Administrator password from the Vault and Start a new session.
#$cert=$(Get-ChildItem Cert:\CurrentUser\My)[1]
#$(Get-CCPCredential -AppID App-PVWA-API -Safe CyberArk-Admin -Username SafeFactory -URL $url -Certificate $cert).ToCredential() | New-CASession
Get-Credential | New-CASession

Import-csv ./test.csv | ForEach-Object{
    $SafeName = $_.SafeName
    $RecSafename = "Rec_" + $SafeName
    $UsersGroup = "CyberArk_$($SafeName)_Users"
    $ManagersGroup = "CyberArk_$($SafeName)_Managers"
    $AuditorsGroup = "CyberArk_$($SafeName)_Auditors"
    
    write-host "Creating $SafeName"
    
    #Create Safes
    New-CASafe $SafeName
    New-CASafe "Rec_$SafeName"
    
    #Add Vault Admins to Safes
    New-CASafeMember -SafeName $SafeName -MemberName "Vault Admins" -SearchIn "Vault" -Permissions $vaultadminsafeperms
    New-CASafeMember -SafeName $RecSafeName -MemberName "Vault Admins" -SearchIn "Vault" -Permissions $vaultadminsafeperms
    
    #Add Users to Safes
    New-CAADGroup $UsersGroup
    New-CASafeMember -SafeName $SafeName -MemberName $UsersGroup -SearchIn "cyber-ark-demo.local" -Permissions $usersafeperms

    #Add Managers to Safes
    New-CAADGroup $ManagersGroup
    New-CASafeMember -SafeName $SafeName -MemberName $ManagersGroup -SearchIn "cyber-ark-demo.local" -Permissions $managersafeperms
    New-CASafeMember -SafeName $RecSafeName -MemberName $ManagersGroup -SearchIn "cyber-ark-demo.local" -Permissions $managerrecsafeperms

    #Add Auditors to Safes
    New-CAADGroup $AuditorsGroup
    New-CASafeMember -SafeName $SafeName -MemberName $AuditorsGroup -SearchIn "cyber-ark-demo.local" -Permissions $auditorsafeperms
    New-CASafeMember -SafeName $RecSafeName -MemberName $AuditorsGroup -SearchIn "cyber-ark-demo.local" -Permissions $auditorrecsafeperms
    
    #Add PSMMaster to Safes
    New-CASafeMember -SafeName $RecSafeName -MemberName "PSMMaster" -SearchIn "Vault" -Permissions $psmrecsafeperms
}
