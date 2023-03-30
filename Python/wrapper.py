import requests
from requests.structures import CaseInsensitiveDict

headers = CaseInsensitiveDict()
headers["Content-Type"] = "application/json"
url = "https://pvwa.acme.corp"

def New_CASession(UserName: str, Password: str):
    global headers, url
    
    # Clear old authorization key if present
    if "Authorization" in headers:
        del headers["Authorization"]
    uri = f"{url}/PasswordVault/api/Auth/cyberark/Logon"
    
    # Convert password back to plaintext in order to create JSON body.
    body = {
        "UserName": UserName,
        "Password": Password.decode(),
        "concurrentSession": "false"
    }
    body = json.dumps(body)

    # Make a logon attempt and add authorization key to header if successful
    try:
        response = requests.post(uri, headers=headers, data=body)
        response.raise_for_status()
        headers["Authorization"] = response.content.decode()
    except requests.exceptions.HTTPError:
        print("Login Failed")
    # Return the Authorization key
    return response.content.decode()

def New_CASafe(SafeName: str, ManagingCPM: str = "PasswordManager", Description: str = "", NumberOfVersionsRetention: int = 10):
    global headers, url
    uri = f"{url}/PasswordVault/WebServices/PIMServices.svc/Safes"
    
    body = {
        "safe": {
            "SafeName": SafeName,
            "Description": Description,
            "OLACEnabled": False,
            "ManagingCPM": ManagingCPM,
            "NumberOfVersionsRetention": NumberOfVersionsRetention
        }
    }
    body = json.dumps(body)

    try:
        response = requests.post(uri, headers=headers, data=body)
        response.raise_for_status()
        result = response.json()["AddSafeResult"]
    except requests.exceptions.HTTPError as e:
        result = f"ErrorCode: {e.response.status_code}\n"
        result += f"Uri: {uri}\n"
        result += f"Body: {body}\n"
        result += "Headers:\n"
        for key, value in headers.items():
            result += f"{key} -> {value}\n"
        # TODO: If creation fails because safe already exists, run Get-Safe and return safe properties anyway
    # Return the result
    return result

def New_CASafeMember(SafeName: str, MemberName: str, SearchIn: str = "Vault", MembershipExpirationDate: str = "", Permissions: dict = {}):
    global headers, url
    uri = f"{url}/PasswordVault/WebServices/PIMServices.svc/Safes/{SafeName}/Members"
    
    body = {
        "member": {
            "MemberName": MemberName,
            "SearchIn": SearchIn,
            "MembershipExpirationDate": MembershipExpirationDate,
            "Permissions": Permissions  
        }
    }
    body = json.dumps(body)

    try:
        response = requests.post(uri, headers=headers, data=body)
        response.raise_for_status()
        result = response.json()["member"]
    except requests.exceptions.HTTPError as e:
        result = f"ErrorCode: {e.response.status_code}\n"
        result += f"Uri: {uri}\n"
        result += f"Body: {body}\n"
        result += "Headers:\n"
        for key, value in headers.items():
            result += f"{key} -> {value}\n"
    # Return the result
    return result
