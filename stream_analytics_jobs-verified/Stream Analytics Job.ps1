#Connect to Azure
#Login-AzureRmAccount(when connecting to the account use this)

#Declare the variables with the values for the different parameters to be passed. Only the values here needs to be changed.
#######################
$templatefile= 'path'    #path to template file
$parameterfile= 'path'   #path to parameter file
$rg= 'RG-IND-TEST-PAAS'                                                    #resource group name
$loc= 'centralindia'                                               #location
$name= 'streamjob1'                                                 #name of stream analytics job
$sku= 'standard'                                                     #pricing tier(Always standard)
$api= '2017-04-01-preview'                                          #api version to be specified
########################

Write-host ("Collected all parameters for " +$name)
#Set the context to the current subscription where the resource group deployment should be done.
$subs= (Get-AzContext).Subscription
Set-AzContext -Subscription $subs
Write-Host ("subscription context is now set to: " +$subs)


#if resource exists, print that it exists and do not create new resource
    if((Get-AzResource -Name $name -ResourceType Microsoft.StreamAnalytics/streamingjobs).Name -eq $name){
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
         New-AzResourceGroupDeployment -ResourceGroupName $rg -TemplateFile $templatefile -TemplateParameterFile $parameterfile -Name $name -ApiVersion $api
         Write-Host ("Resource created: " +$name)
         break
        }

        else
        {
        # Do resource deployment only
        
            New-AzResourceGroupDeployment -ResourceGroupName $rg -TemplateFile $templatefile -TemplateParameterFile $parameterfile -Name $name -ApiVersion $api
            Write-Host ("Resource created: " +$name)
        }
    }