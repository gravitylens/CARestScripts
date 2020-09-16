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