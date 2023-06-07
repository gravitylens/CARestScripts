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
# Headers
$headers = @{"content-type" = "application/json"}

# URI
$uri="https://pvwa.acme.corp/PasswordVault/api/Auth/cyberark/Logon"

# HTTP Method
$method = "POST"

# Body
$body = @{
    username = "SafeFactory"
    password = "Cyberark1"
    concurrentSession = "false"
} | ConvertTo-Json

# Invoke Rest Method
$response = Invoke-RestMethod -uri $uri -Method $method -Headers $headers -Body $body

#Add response to headers and return
$headers += @{"authorization" = $response}
write-host $response
