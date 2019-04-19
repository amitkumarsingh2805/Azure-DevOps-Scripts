#Let's set our subscription context
Connect-AzureRmAccount -Subscription "Demonstration Account"

#And get a listing of VMs
Get-AzureRmVM

#We can store PowerShell scripts in our cloud drive too
cd ~/clouddrive

#Create a simple script and add a cmdlet to it
vi demo.ps1
Get-AzureRmVM

#Run our script
./demo.ps1
