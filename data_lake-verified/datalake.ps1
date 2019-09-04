﻿#Connect to Azure
Connect-AzAccount

#Declare the variables with the values for the different parameters to be passed. Only the values here needs to be changed.
#######################

$templatefile= 'C:\Users\roopsa.d\Desktop\DONE\datalake\template.json'    #path to template file
$parameterfile= 'C:\Users\roopsa.d\Desktop\DONE\datalake\parameters.json' #path to parameter file
$name='adlstest123test'
$loc= 'eastus'
$rg= 'testabc123'


#if resource exists, print that it exists and do not create new resource
    if((Get-AzResource -Name $name -ResourceType Microsoft.Web/sites).Name -eq $name){
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
         New-AzResourceGroupDeployment -nameFromTemplate $name -ResourceGroupName $rg -TemplateFile $templatefile -TemplateParameterFile $parameterfile
         Write-Host ("Resource created: " +$name)
         break
        
        }
        else
        {
        # Do resource deployment only
        
          New-AzResourceGroupDeployment -nameFromTemplate $name -ResourceGroupName $rg -TemplateFile $templatefile -TemplateParameterFile $parameterfile
          Write-Host ("Resource created: " +$name)
        }
    }




#we use the incremental mode to avoid deletion of existing resources which will not be used for this deployment. Often that is the case is Complete mode.