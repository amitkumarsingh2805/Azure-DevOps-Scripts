#Connect to Azure Account
Connect-AzureRMAccount

#Declare the variables with the values for the different parameters to be passed. Only the values here needs to be changed.
#######################
         
$templatefile= 'C:\Users\ritik.d\Desktop\web-app\AzureCosmosDB\Azure-CosmosDB.json'    		#path to template file
$parameterfile= 'C:\Users\ritik.d\Desktop\web-app\AzureCosmosDB\Azure-CosmosDBparameter.json' 	  	#path to parameter file
$rg= 'shw'                                                    			#resource group name
$loc= 'centralus'                                               		#location
$accountName= 'shw-CosmosDB'											#CosmosDB name
$location= 'East US 2'								                    #Location for the CosmosDB Account
$primaryRegion= 'East US 2'        									    #primary replica region for the Cosmos DB account
$secondaryRegion= 'West US '											#secondary replica region for the Cosmos DB account
$api= 'Sql'                                                				#Cosmos DB account type
$maxStalenessPrefix= '100000'											#Max stale requests,Required for BoundedStaleness.Valid ranges, Single Region: 10 to 1000000. Multi Region: 100000 to 1000000.
$automaticFailover= 'false'												#Enable automatic failover for regions	
$name=$accountName
########################


Write-Host ("all parameters were successfully collected.")
#Set the context to the current subscription where the resource group deployment should be done.
$subs= 'cd900bc9-f67e-4873-9d53-eedd4d3fcca9'
Select-Azurermsubscription -Subscription $subs
Write-Host ("subscription context is now set to: " +$subs)

#Execute the resource group deployment template.
#if resource exists, print that it exists and do not create new resource
    if((Get-AzurermResource -Name $name -ResourceType Microsoft.DocumentDB/databaseAccounts).Name -eq $name){
        Write-Host ("Resource with the given name exists: "+$name)
    }

#if resource does not exist, run the loop
    else{
        Get-AzurermResourceGroup -Name $rg -ErrorVariable notPresent -ErrorAction SilentlyContinue
        if ($notPresent)
        {
        # Do resource group deployment if resource group does not exist by creating new resource group and then create the resource
         Write-Host ("Resource group does not exist. Creating new resource group: " +$rg)
         New-AzurermResourceGroup -Name $rg -Location $loc
         Write-Host("Successfully created new resource group: " +$rg)
         New-AzurermResourceGroupDeployment -ResourceGroupName $rg -accountName $accountName -primaryRegion $primaryRegion -secondaryRegion $secondaryRegion -api $api -maxStalenessPrefix $maxStalenessPrefix -automaticFailover $automaticFailover -TemplateFile -$templatefile -TemplateParameterFile $parameterfile
         Write-Host ("Resource created: " +$name)
         break
        #...same for ASP
        }
        else
        {
        # Do resource deployment only
          New-AzurermResourceGroupDeployment -ResourceGroupName $rg -accountName $accountName -primaryRegion $primaryRegion -secondaryRegion $secondaryRegion -api $api -maxStalenessPrefix $maxStalenessPrefix -automaticFailover $automaticFailover -TemplateFile -$templatefile -TemplateParameterFile $parameterfile
          Write-Host ("Resource created: " +$name)
        }
    }