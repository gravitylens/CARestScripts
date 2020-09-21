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
$global:url = "https://comp01a.cyber-ark-demo.local/passwordvault/api"

$uri="$url/Auth/cyberark/Logon"

$body = @{
    username = "Administrator"
    password = "Cyberark1"
    concurrentSession = "false"
} | ConvertTo-Json

$response = Invoke-RestMethod -uri $uri -Method 'POST' -Headers $headers -Body $body
$global:headers.Add("Authorization", $response)
write-host $response