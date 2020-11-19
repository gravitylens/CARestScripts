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

$Permissions=@(
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

#Test without Secure String
#New-CASession -username "SafeFactory" -password "Cyberark1"

#Test with Secure String
Get-Credential -UserName "SafeFactory" | New-CASession
@("Safe4", "Safe5", "Safe6")| New-CASafe | New-CASafeMember -MemberName "Vault Admins" -Permissions $Permissions
