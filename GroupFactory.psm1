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
Import-Module ActiveDirectory
$ADCred = New-Object System.Management.Automation.PSCredential("ACME\Administrator",$(ConvertTo-SecureString "Cyberark1" -AsPlainText -Force))

function New-CAADGroup {
    param (
        [string]$GroupName
    )
    New-ADGroup -credential $adcred -server "dc01.acme.corp" -Name $groupname -SamAccountName $groupname -GroupCategory Security -GroupScope Global -DisplayName $groupname -Path "OU=Groups,OU=CyberArk,OU=Domain Users and Groups,DC=acme,DC=corp"
}