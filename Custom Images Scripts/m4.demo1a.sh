#Deprovisioning and creating a Linux custom image using Azure CLI

#Ensure we're using bash for this demo
bash

#login interactively and set a subscription to be the current active subscription
az login --subscription "Demonstration Account"

#Find the IP of the VM we want to build a custom image from.
az vm list-ip-addresses --name "psdemo-linux-1" --output table

#Connect to the virtual machine via ssh
ssh demoadmin@168.61.212.180

#Deprovision the virtual machine
sudo waagent -deprovision+user -force

#log out of the VM
exit

#In Azure CLI, deallocate the virtual machine
az vm deallocate \
    --resource-group "psdemo-rg" \
    --name "psdemo-linux-1"

#Check out the status of our virtual machine
az vm list \
    --show-details \
    --output table

#Mark the virtual machine as "generalized"
az vm generalize \
    --resource-group "psdemo-rg" \
    --name "psdemo-linux-1"

#Create a VM from the custom image we just created, simply specify the image as a source.
#Defaults to LRS, add the --zone-resilient  option for ZRS if supported in your Region.
az image create \
    --resource-group "psdemo-rg" \
    --name "psdemo-linux-ci-1" \
    --source "psdemo-linux-1"

#Summary image information
az image list \
    --output table

#More detailed image information, specifically this is a managed disk.
az image list

#Create a VM specifying the image we want to use
az vm create \
    --resource-group "psdemo-rg" \
    --location "centralus" \
    --name "psdemo-linux-1c" \
    --image "psdemo-linux-ci-1" \
    --admin-username "demoadmin" \
    --authentication-type "ssh" \
    --ssh-key-value ~/.ssh/id_rsa.pub

#Check out the status of our provisioned VM from the Image and also our source VM is still deallocated.
az vm list \
    --show-details \
    --output table

#Try to start our generalized image, you cannot. 
#If you want to keep the source VM around...then copy the VM, generalize the copy and continue to use the source VM.
az vm start \
    --name "psdemo-linux-1" \
    --resource-group "psdemo-rg"

#You can delete the deallocated source VM
az vm delete \
    --name "psdemo-linux-1" \
    --resource-group "psdemo-rg"

#Which will leave just the Image in our Resource Group as a managed resource.
az resource list \
    --resource-type=Microsoft.Compute/images \
    --output table
