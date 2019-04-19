#Launch CloudDrive and maximize the window.

#Azure Drive can be used to discover systems and settings in our Azure environment
Get-ChildItem "./Demonstration Account/"

#We can find a list of VMs
Get-ChildItem "./Demonstration Account/VirtualMachines/"

#We can also perform operaitions on those VMs
Get-ChildItem './Demonstration Account/VirtualMachines/psdemo-linux-1a' | Stop-AzureRmVM -WhatIf


#In CloudShell we have Azure CLI
az account set --subscription "Demonstration Account"

#We can use all commands available in Azure CLI to control our environment
az vm list --output table

#CloudDrive is located in the home directory, so change into that.
cd ~

#A directory listing shows the clouddrive directory, let's change into that directory
ls
cd clouddrive

#create a demo script in our clouddrive and save it out.
vi demo.sh
#!/bin/bash
az vm list --output table

#Mark the script usermode executable
chmod u+x demo.sh

#Run the script
./demo.sh