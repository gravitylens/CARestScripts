from wrapper import *
import getpass

# Import wrapper module and define permissions dictionary
permissions = {
    "useAccounts": True,
    "retrieveAccounts": True,
    "listAccounts": True,
    "addAccounts": True,
    "updateAccountContent": True,
    "updateAccountProperties": True,
    "initiateCPMAccountManagementOperations": True,
    "specifyNextAccountContent": True,
    "renameAccounts": True,
    "deleteAccounts": True,
    "unlockAccounts": True,
    "manageSafe": True,
    "manageSafeMembers": True,
    "backupSafe": True,
    "viewAuditLog": True,
    "viewSafeMembers": True,
    "accessWithoutConfirmation": True,
    "createFolders": True,
    "deleteFolders": True,
    "moveAccountsAndFolders": True,
    "requestsAuthorizationLevel1": True,
    "requestsAuthorizationLevel2": False
}

# Call New-CASession function with secure string password
username = "SafeFactory"
password = getpass.getpass("Enter your password: ")
response = New_CASession(username, password)
print("New-CASession response:", response)

# Call New-CASafe and New-CASafeMember functions
safe_names = ["Safe1", "Safe2", "Safe3"]
for safe_name in safe_names:
    result = New_CASafe(safe_name)
    print("New-CASafe result:", result)
    result = New_CASafeMember(safe_name, "Vault Admins", Permissions=permissions)
    print("New-CASafeMember result:", result)
