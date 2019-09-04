#Connect to Azure
Connect-AzAccount

#Declare the variables with the values for the different parameters to be passed. Only the values here needs to be changed.
#######################

$templatefile= 'C:\Users\roopsa.d\Desktop\DONE\databricks\template.json'    #path to template file
$parameterfile= 'C:\Users\roopsa.d\Desktop\DONE\databricks\parameters.json' #path to parameter file
$rg= 'testabc123'                                                    #resource group name
$loc= 'northcentralus'                                               #location
$name= 'testdatabricks'                                               #name of workspace
$sku= 'Standard' #or Premium or Trial                                 #pricing tier
########################


#if resource exists, print that it exists and do not create new resource
    if((Get-AzResource -Name $name -ResourceType Microsoft.Databricks/workspaces).Name -eq $name){
        Write-Host ("Resource with the given name exists: "+$name)
    }

#if resource does not exist, run the loop
    else{
        Get-AzResourceGroup -Name $rg -ErrorVariable notPresent -ErrorAction SilentlyContinue
        if ($notPresent)
        {
        # Do resource group deployment if resource group does not exist by creating new resource group and then create the resource
         Write-Host ("Resource group does not exist. Creating new resource group: " +$rg)
         New-AzResourceGroup -Name $rg -Location $loc
         Write-Host("Successfully created new resource group: " +$rg)
         New-AzResourceGroupDeployment -ResourceGroupName $rg -location $loc -workspaceName $name -tier $sku -TemplateFile $templatefile -TemplateParameterFile $parameterfile
         Write-Host ("Resource created: " +$name)
         break
        
        }
        else
        {
        # Do resource deployment only
        
          New-AzResourceGroupDeployment -ResourceGroupName $rg -location $loc -workspaceName $name -tier $sku -TemplateFile $templatefile -TemplateParameterFile $parameterfile
          Write-Host ("Resource created: " +$name)
        }
    }
