#!/bin/bash

headers="Content-Type: application/json"
url="https://pvwa.acme.corp"

uri="$url/PasswordVault/api/Auth/cyberark/Logon"

body='{
    "username": "SafeFactory",
    "password": "Cyberark1",
    "concurrentSession": "false"
}'

response=$(curl -s -X POST -H "$headers" -d "$body" "$uri")

echo $response
