#Connect to Azure
Connect-AzurermAccount #(when connecting to the account use this)

#Declare the variables with the values for the different parameters to be passed. Only the values here needs to be changed.
#######################

$templatefile= 'C:\Users\ritik.d\Desktop\web-app\Azure-Rediscache\Azure-Rediscache.json'                               #path to template file
$parameterfile= 'C:\Users\ritik.d\Desktop\web-app\Azure-Rediscache\Azure-Rediscacheparameter.json'                             # path to parameter file
$rg= 'shw'                                               #resource group name
$loc= 'centralus'                                           #location

$redisCacheName= 'shw-Rediscache'	                                                #name of rediscache namespaceName
$name= $redisCacheName								            
$redisCacheSKU= 'Standard'         									    #Pricing tier for the Redis Cache
$redisCacheFamily= 'C'													#Family for the SKU
$redisCacheCapacity= '1'                                                #Size of the redis cache instance

########################
Write-host ("Collected all parameters for " +$name)
#Set the context to the current subscription where the resource group deployment should be done.
$subs= 'cd900bc9-f67e-4873-9d53-eedd4d3fcca9'
Select-Azurermsubscription -Subscription $subs
Write-Host ("subscription context is now set to: " +$subs)

#Create a new resource group
#New-AzResourceGroup -Name testabc123 -Location northcentralus(if new resource group is required)

#if resource exists, print that it exists and do not create new resource
    if((Get-AzurermResource -Name $name -ResourceType Microsoft.Cache/Redis).Name -eq $name){
        Write-Host ("Resource with the given name exists: "+$name)
     }

#else if resource does not exist, run the loop
    else{
        Get-AzurermResourceGroup -Name $rg -ErrorVariable notPresent -ErrorAction SilentlyContinue
        if ($notPresent)
        {
    
        # Do resource group deployment if resource group does not exist by creating new resource group and then create the resource
        Write-Host ("Resource group does not exist. Creating new resource group: " +$rg)
         New-AzurermResourceGroup -Name $rg -Location $loc
         Write-Host("Successfully created new resource group: " +$rg)
         New-AzurermResourceGroupDeployment -ResourceGroupName $rg -location $loc -redisCacheName $redisCacheName -existingDiagnosticsStorageAccountId $existingStorageAccountId  -redisCacheSKU $redisCacheSKU -redisCacheFamily $redisCacheFamily -redisCacheCapacity $redisCacheCapacity -TemplateFile $templatefile -TemplateParameterFile $parameterfile
         Write-Host ("Resource created: " +$name)
         break
        }

        else
        {
        # Do resource deployment only
        
         New-AzurermResourceGroupDeployment -ResourceGroupName $rg -redisCacheName $redisCacheName -existingDiagnosticsStorageAccountId $existingStorageAccountId  -redisCacheSKU $redisCacheSKU -redisCacheFamily $redisCacheFamily -redisCacheCapacity $redisCacheCapacity -TemplateFile $templatefile -TemplateParameterFile $parameterfile
            Write-Host ("Resource created: " +$name)
        }
    }