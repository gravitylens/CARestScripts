# CARestScripts
The repository contains completed scripts from CyberArk's "Automation with RestAPI" Course.

## Simple Login Script
In this exercise you were asked to create a basic script that calls a single RestAPI method.  Specifically the script should sign into the PVWA and create all the headers needed for further Rest Methods in a $global:headers variable.  You can find a working example of this script in the following file.

    ./testlogin.ps1 

## Prototyping Complex Automations
In this exercise you were asked to test several Rest methods in Postman.  You can import a collection of working Rest calls into Postman from the following file.

[//]: <> (TODO: Create this file)

## Creating a Powershell Wrapper
In this exercise you were asked to create a Powershell wrapper that implemented three functions.
1. **New-CASession**, which will login to the PVWA and create the headers needed for subsequent Rest methods.
1. **New-CASafe**, which will create a safe.
1. **New-CASafeMember**, which will add a member to a safe and set its permissions.

You can find a working version of this module in the following file.

    ./wrapper.psm1

## CyberArk Safe Factory
In this exercise you were asked to create a script that builds safes and assigns members to safes with the appropriate permissions using either your own Powershell module or the [psPAS](https://github.com/pspete/psPAS) module.  You can find a working example of this script in the following file.

    ./SafeFactory.psm1

Note: The following exercises has already been completed in this example.  Lines that required alteration have been preserved in the comments.

## Securing RestAPI Scripts
In this exercise you were asked to modify your SafeFactory script in order to retrieve its credentials from the vault rather than hard coding them or prompting for user input.  These changes have already been completed in the sample above, and the required changes noted in the comments.