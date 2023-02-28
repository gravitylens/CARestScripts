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
Import-Module -Force ./wrapper.psm1

$permissions=@{
    "useAccounts"=$true;
    "retrieveAccounts"=$false;
    "listAccounts"=$true;
    "addAccounts"=$false;
    "updateAccountContent"=$false;
    "updateAccountProperties"=$false;
    "initiateCPMAccountManagementOperations"=$false;
    "specifyNextAccountContent"=$false;
    "renameAccounts"=$false;
    "deleteAccounts"=$false;
    "unlockAccounts"=$false;
    "manageSafe"=$false;
    "manageSafeMembers"=$false;
    "backupSafe"=$false;
    "viewAuditLog"=$false;
    "viewSafeMembers"=$false;
    "accessWithoutConfirmation"=$false;
    "createFolders"=$false;
    "deleteFolders"=$false;
    "moveAccountsAndFolders"=$false;
    "requestsAuthorizationLevel1"=$false;
    "requestsAuthorizationLevel2"=$false
}

#Test without Secure String
#New-CASession -username "SafeFactory" -password "Cyberark1"

#Test with Secure String
Get-Credential -UserName "SafeFactory" | New-CASession
@("Safe4", "Safe5", "Safe6")| New-CASafe | New-CASafeMember -MemberName "Vault Admins" -Permissions $Permissions
