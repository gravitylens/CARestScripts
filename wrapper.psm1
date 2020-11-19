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
$global:headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$global:headers.Add("Content-Type", "application/json")
$global:url = "https://pvwa.acme.corp"

function New-CASession{
    Param(
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Mandatory=$true
        )]
        [string]$UserName, 
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Mandatory=$true
        )]
        [SecureString]$Password
    )
    
    #Clear Old Authorization Key if Present
    if($headers.ContainsKey("Authorization")){
        $global:headers.Remove("Authorization")
    }
    $uri="$url/PasswordVault/api/Auth/cyberark/Logon"

    #Convert Password back to plaintext in order to create JSON body.
    #TODO: See if there is a way to avoid plaintext conversion.
    $body = @{
        UserName = $UserName
        Password = ConvertFrom-SecureString -SecureString $Password -AsPlainText
        concurrentSession = "false"
    } | ConvertTo-Json

    #Make a logon attempt and add authorization key to header if successful
    Try{
        $response = Invoke-RestMethod -uri $uri -Method 'POST' -Headers $headers -Body $body
        $global:headers.Add("Authorization",$response)
    }
    #If unsuccessfull display simple error message
    Catch {
        write-host "Login Failed"
    }
    #Return the Authorization key to STDOUT
    return $response;
}

function New-CASafe{
    Param(
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Mandatory=$true
        )]
        [string]$SafeName,
        [Alias("CPM")]
        [Parameter(
            #ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Mandatory=$false
        )]
        [string]$ManagingCPM="PasswordManager",
        [Parameter(
            #ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Mandatory=$false
        )]
        [string]$Description,
        [Alias("Versions")]
        [Parameter(
            #ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Mandatory=$false
        )]
        [int]$NumberOfVersionsRetention=10
    )
    BEGIN{
        $uri="$url/PasswordVault/WebServices/PIMServices.svc/Safes"
    }
    PROCESS{
        $body=@{
            "safe"= @{
                "SafeName"=$SafeName
                "Description"=$Description
                "OLACEnabled"=$false
                "ManagingCPM"=$ManagingCPM
                "NumberOfVersionsRetention"=$NumberOfVersionsRetention
            }
        } | ConvertTo-Json

        Try{
            $response = Invoke-RestMethod -uri $uri -Method 'POST' -Headers $headers -Body $body
        }
        #If unsuccessfull display simple error message
        #TODO: If creation fails because safe already exists run Get-Safe and return safe properties anyway
        Catch {
            write-host "Unable to create safe $SafeName."
            #TODO: Include an error message as well.
        }
        #Return Safe Properties to STDOUT
        return $response.AddSafeResult;
    }
    END{

    }
}

function New-CASafeMember{
    Param(
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Mandatory=$true
        )]
        [string]$SafeName,
        [Alias("Member")]
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Mandatory=$true
        )]
        [string]$MemberName,
        [Parameter(
            ValueFromPipeline=$false,
            ValueFromPipelineByPropertyName=$true,
            Mandatory=$false
        )]
        [string]$SearchIn="Vault",
        [Alias("Expires")]
        [Parameter(
            ValueFromPipeline=$false,
            ValueFromPipelineByPropertyName=$true,
            Mandatory=$false
        )]
        [string]$MembershipExpirationDate="",
        [Alias("Perms")]
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Mandatory=$true
        )]
        [psobject]$Permissions
    )
   
    PROCESS{
        $uri="$url/PasswordVault/WebServices/PIMServices.svc/Safes/$SafeName/Members"
        $body = @{
            "member"= @{
                "MemberName"=$MemberName
                "SearchIn"=$SearchIn
                "MembershipExpirationDate"=$MembershipExpirationDate
                "Permissions"=$Permissions  
            }
        } | ConvertTo-Json -Depth 3

        Try{
            $response = Invoke-RestMethod -uri $uri -Method 'POST' -Headers $headers -Body $body
        }
        Catch{
            write-host "Unable to add $MemberName to $SafeName"            
            #TODO: Include an error message.
        }
        #Return Details of the ACL to STDOUT
        return $response.member
    }
}