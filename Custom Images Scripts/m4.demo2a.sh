#Demo Setup
az extension remove --name image-copy-extension

#login interactively and set a subscription to be the current active subscription
az login --subscription "Demonstration Account"

#0 - List the images in our Subscription
az image list --output table

#1 - Let's say we started a new Resoruce Group in the East US Region.
az group create \
    --name "psdemo-rg-1" \
    --location "eastus"

#2 - Let's try to create a VM from a custom image that's in another Azure Region, which will error out...
az vm create \
    --location "eastus" \
    --resource-group "psdemo-rg-1" \
    --name "psdemo-linux-1e" \
    --image "psdemo-linux-ci-1" \
    --admin-username demouser \
    --ssh-key-value ~/.ssh/id_rsa.pub

#3 - We need to get a copy of our image into that Azure Region, we'll need the image copy extension for that.
#For more info on this extension and the copy process see: 
#   https://www.microsoft.com/developerblog/2018/02/15/copy-custom-vm-images-on-azure/
#For more info on how to do this in PowerShell: 
#   https://michaelcollier.wordpress.com/2017/05/03/copy-managed-images/
az extension add \
    --name image-copy-extension

#4 - Then we can copy our image between our Resource Groups and Regions. Creates a Temp Storage Account, then cleans it up.
#May take 5-10 minutes
az image copy \
    --source-object-name "psdemo-linux-ci-1" \
    --source-resource-group "psdemo-rg" \
    --target-location "eastus" \
    --target-resource-group "psdemo-rg-1" \
    --target-name "psdemo-linux-ci-1-east" \
    --cleanup

#List all images in our Subscription
az image list \
    --output table


#5 - Retry, creating a VM in the new RG, in the East US Region where our image has been copied.
az vm create \
    --location "eastus" \
    --resource-group "psdemo-rg-1" \
    --name "psdemo-linux-1e" \
    --image "psdemo-linux-ci-1-east" \
    --admin-username demouser \
    --ssh-key-value ~/.ssh/id_rsa.pub

#6 - Look at our currently provisioned VMs
az vm list \
    --output table

#7 - Delete an specific image
az image delete \
    --resource-group "psdemo-rg-1" \
    --name "psdemo-linux-ci-1-east" 

#7 - Custom Images in the Azure Portal
#Sort by type, click on one of our images.
open 'https://portal.azure.com/#@nocentinohotmail.onmicrosoft.com/resource/subscriptions/fd0c5e48-eea6-4b37-a076-0e23e0df74cb/resourceGroups/psdemo-rg/overview'
