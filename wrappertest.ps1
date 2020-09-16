Import-Module -Force ./wrapper.psm1

Get-Credential -UserName "Administrator" | New-CASession

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
#     @{"Key"="BackupSafe"; "Value"=$true},
     @{"Key"="ViewAuditLog"; "Value"=$true},
     @{"Key"="ViewSafeMembers"; "Value"=$true},
#     @{"Key"="RequestsAuthorizationLevel"; "Value"=1},
     @{"Key"="AccessWithoutConfirmation"; "Value"=$true},
     @{"Key"="CreateFolders"; "Value"=$true},
     @{"Key"="DeleteFolders"; "Value"=$true},
     @{"Key"="MoveAccountsAndFolders"; "Value"=$true}
)

@("ASafe45","ASafe46", "ASafe47") | New-CASafe | New-CASafeMember -Member "Vault Admins" -Permissions $Permissions