#Connect to Azure
Login-AzureRmAccount

#Declare the variables with the values for the different parameters to be passed. Only the values here needs to be changed.
#######################

$templatefile= 'C:\Users\roopsa.d\Downloads\ARM\ARM Template\AppInsight\AppInsightTemplate.json'    #path to template file
$parameterfile= 'C:\Users\roopsa.d\Downloads\ARM\ARM Template\AppInsight\AppInsightParameters.json' #path to parameter file
$rg= 'RG-IND-TEST-PAAS'                                                    #resource group name
#$loc= 'northcentralus'                                               #location
$name= 'test'                                                 #name
#$sku= 'Standard' #or Premium                                         #pricing tier

########################
Write-Host ("all parameters were successfully collected.")
#Set the context to the current subscription where the resource group deployment should be done.
$subs= (Get-AzContext).Subscription
Set-AzContext -Subscription $subs
Write-Host ("subscription context is now set to: " +$subs)

#Execute the resource group deployment template.
#if resource exists, print that it exists and do not create new resource
    if((Get-AzResource -Name $name -ResourceType microsoft.insights/components).Name -eq $name){
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
         New-AzResourceGroupDeployment -ResourceGroupName $rg -nameFromTemplate $name -TemplateFile $templatefile -TemplateParameterFile $parameterfile
         Write-Host ("Resource created: " +$name)
         break
        #...same for ASP
        }
        else
        {
        # Do resource deployment only
        
          New-AzResourceGroupDeployment -ResourceGroupName $rg -nameFromTemplate $name -TemplateFile $templatefile -TemplateParameterFile $parameterfile
          Write-Host ("Resource created: " +$name)
        }
    }