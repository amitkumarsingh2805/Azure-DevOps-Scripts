#Connect to Azure
#Connect-AzAccount(when connecting to the account use this)

#Declare the variables with the values for the different parameters to be passed. Only the values here needs to be changed.
#######################

$templatefile= 'path of template file'                               #path to template file
$parameterfile= 'path of parameter file'                             # path to parameter file
$rg= 'RG-IND-TEST-PAAS'                                              #resource group name
$loc= 'centralindia'                                               #location
$name= 'newnspc'                                                 #name of notification namespaceName
$sku= 'Free' #or Basic or Standard                                         #pricing tier
########################
Write-host ("Collected all parameters for " +$name)
#Set the context to the current subscription where the resource group deployment should be done.
$subs= (Get-AzContext).Subscription
Set-AzContext -Subscription $subs
Write-Host ("subscription context is now set to: " +$subs)

#Create a new resource group
#New-AzResourceGroup -Name testabc123 -Location northcentralus(if new resource group is required)

#if resource exists, print that it exists and do not create new resource
    if((Get-AzResource -Name $name -ResourceType Microsoft.NotificationHubs/namespaces).Name -eq $name){
        Write-Host ("Resource with the given name exists: "+$name)
     }

#else if resource does not exist, run the loop
    else{
        Get-AzResourceGroup -Name $rg -ErrorVariable notPresent -ErrorAction SilentlyContinue
        if ($notPresent)
        {
    
        # Do resource group deployment if resource group does not exist by creating new resource group and then create the resource
        Write-Host ("Resource group does not exist. Creating new resource group: " +$rg)
         New-AzResourceGroup -Name $rg -Location $loc
         Write-Host("Successfully created new resource group: " +$rg)
         New-AzResourceGroupDeployment -ResourceGroupName $rg -TemplateFile $templatefile -TemplateParameterFile $parameterfile -Name $name
         Write-Host ("Resource created: " +$name)
         break
        }

        else
        {
        # Do resource deployment only
        
            New-AzResourceGroupDeployment -ResourceGroupName $rg -TemplateFile $templatefile -TemplateParameterFile $parameterfile -Name $name
            Write-Host ("Resource created: " +$name)
        }
    }