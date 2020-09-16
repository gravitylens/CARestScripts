Import-Module ActiveDirectory
$ADCred = New-Object System.Management.Automation.PSCredential("Administrator",$(ConvertTo-SecureString "Cyberark1" -AsPlainText -Force))

function New-CAADGroup {
    param (
        [string]$GroupName
    )
    New-ADGroup -credential $adcred -server "dc01.cyber-ark-demo.local" -Name $groupname -SamAccountName $groupname -GroupCategory Security -GroupScope Global -DisplayName $groupname -Path "OU=Cyber-Ark Groups,DC=cyber-ark-demo,DC=local"
}