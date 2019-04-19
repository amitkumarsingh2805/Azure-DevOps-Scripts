#Setup
#1 - Logged into Azure CLI, with az login
#2 - Deleted the Resource Group ps-demo from the previous demo.
#3 - Ensure you're in a bash terminal session.

#Demo outline
#1 - Create a Linux VM, specifying individual resources. Connect via SSH.
#2 - Create a Linux VM, using a quick, short configuration.
#3 - Create a Windows VM, specifying individual resources. Connect via RDP.

#installing Azure CLI
brew update && brew install azure-cli

#Installing for other OSs is available here:
#https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

#Login interactively and set a subscription to be the current active subscription
az login --subscription "Demonstration Account"

#Let's create a Linux VM, starting off with creating a Resource Group.

#1 - Create a resource group, then query the list of resource groups in our subscription
az group create \
    --name "psdemo-rg" \
    --location "centralus"

az group list -o table

#2 - Create virtual network (vnet) and Subnet
az network vnet create \
    --resource-group "psdemo-rg" \
    --name "psdemo-vnet-1" \
    --address-prefix "10.1.0.0/16" \
    --subnet-name "psdemo-subnet-1" \
    --subnet-prefix "10.1.1.0/24"

az network vnet list -o table

#3 - Create public IP address
az network public-ip create \
    --resource-group "psdemo-rg" \
    --name "psdemo-linux-1-pip-1"

#Public IPs can take a few minutes to provision, we'll check on this after we provision the VM

#4 - Create network security group
az network nsg create \
    --resource-group "psdemo-rg" \
    --name "psdemo-linux-nsg-1"

az network nsg list --output table

#5 - Create a virtual network interface and associate with public IP address and NSG
az network nic create \
  --resource-group "psdemo-rg" \
  --name "psdemo-linux-1-nic-1" \
  --vnet-name "psdemo-vnet-1" \
  --subnet "psdemo-subnet-1" \
  --network-security-group "psdemo-linux-nsg-1" \
  --public-ip-address "psdemo-linux-1-pip-1"

az network nic list --output table

#6 - Create a virtual machine
az vm create \
    --resource-group "psdemo-rg" \
    --location "centralus" \
    --name "psdemo-linux-1" \
    --nics "psdemo-linux-1-nic-1" \
    --image "rhel" \
    --admin-username "demoadmin" \
    --authentication-type "ssh" \
    --ssh-key-value ~/.ssh/id_rsa.pub 

#The VM may take a few minutes to create...let's bend spacetime.

az vm create --help | more 

#7 - Open port 22 to allow SSH traffic to host
az vm open-port \
    --resource-group "psdemo-rg" \
    --name "psdemo-linux-1" \
    --port "22"

#8 - Grab the public IP of the virtual machine
az vm list-ip-addresses --name "psdemo-linux-1" --output table

ssh -l demoadmin 168.61.212.180

#Let's create a VM with minimal specifications and using default settings
#1 - Quick and dirty VM creation...this will get placed onto our current vnet/subnet
az vm create \
    --resource-group "psdemo-rg" \
    --name "psdemo-linux-1a" \
    --image "UbuntuLTS" \
    --admin-username "demoadmin" \
    --authentication-type "ssh" \
    --ssh-key-value ~/.ssh/id_rsa.pub

#Take a few minutes to provision...this.Bend(SpaceTime)

#2 - Open 22 for ssh access to the VMs,
az vm open-port \
    --resource-group "psdemo-rg" \
    --name "psdemo-linux-1a" \
    --port "22"

#3 - Grab the public IP of the virtual machine
az vm list-ip-addresses --name "psdemo-linux-1a" --output table

ssh -l demoadmin 23.99.253.177

## Time to create the Windows VM ##
#1 - we're going to place this server in the existing resource group.

#2 - we're going to place this server in the same vnet

#3 - Create public IP address
az network public-ip create \
    --resource-group "psdemo-rg" \
    --name "psdemo-win-1-pip-1"

#4 - Create network security group, so we can have seperate security policies
az network nsg create \
    --resource-group "psdemo-rg" \
    --name "psdemo-win-nsg-1"

#5 - Create a virtual network card and associate with public IP address and NSG
az network nic create \
  --resource-group "psdemo-rg" \
  --name "psdemo-win-1-nic-1" \
  --vnet-name "psdemo-vnet-1" \
  --subnet "psdemo-subnet-1" \
  --network-security-group "psdemo-win-nsg-1" \
  --public-ip-address "psdemo-win-1-pip-1"

#6 - Create a virtual machine
az vm create \
    --resource-group "psdemo-rg" \
    --name "psdemo-win-1" \
    --location "centralus" \
    --nics "psdemo-win-1-nic-1" \
    --image "win2016datacenter" \
    --admin-username "demoadmin" \
    --admin-password "password123412123$%^&*"

#7 - Open port 3389 to allow RDP traffic to host
az vm open-port \
    --port "3389" \
    --resource-group "psdemo-rg" \
    --name "psdemo-win-1"

az vm list-ip-addresses --name "psdemo-win-1"  --output table

#Use Remote Desktop to connect to to this VM
