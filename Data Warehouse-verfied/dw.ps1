#Connect to Azure
#Connect-AzAccount(when connecting to the account use this)

#Declare the variables with the values for the different parameters to be passed. Only the values here needs to be changed.
#######################

$templatefile= 'C:\Users\ritik.d\Desktop\web-app\dw-template.json'                               #path to template file
$parameterfile= 'C:\Users\ritik.d\Desktop\web-app\dw-parameter.json'                             # path to parameter file
$rg= 'sam12'                                              #resource group name
$loc= 'centralus'                                               #location
$name= 'newnspc'                                                 #name of notification namespaceName
$sku= 'Free' #or Basic or Standard                                         #pricing tier
$sqlAdministratorLogin = 'dante'      									#SQL Administrator username                                  

$sqlAdministratorLoginPassword = ConvertTo-SecureString 'Humh0g3k@my@b'	-AsPlainText -Force					#SQL Administrator Password
$transparentDataEncryption = 'Disabled'									#Encryption

########################
Write-host ("Collected all parameters for " +$name)
#Set the context to the current subscription where the resource group deployment should be done.
$subs= 'cd900bc9-f67e-4873-9d53-eedd4d3fcca9'
Select-Azurermsubscription -Subscription $subs
Write-Host ("subscription context is now set to: " +$subs)

#Create a new resource group
#New-AzResourceGroup -Name testabc123 -Location northcentralus(if new resource group is required)

#if resource exists, print that it exists and do not create new resource
    if((Get-AzurermResource -Name $name -ResourceType Microsoft.Sql/servers).Name -eq $name){
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
         New-AzurermResourceGroupDeployment -ResourceGroupName $rg -sqlAdministratorLogin $sqlAdministratorLogin -sqlAdministratorLoginPassword $sqlAdministratorLoginPassword -TemplateFile $templatefile -TemplateParameterFile $parameterfile
         Write-Host ("Resource created: " +$name)
         break
        }

        else
        {
        # Do resource deployment only
        
         New-AzurermResourceGroupDeployment -ResourceGroupName $rg -sqlAdministratorLogin $sqlAdministratorLogin -sqlAdministratorLoginPassword $sqlAdministratorLoginPassword -TemplateFile $templatefile -TemplateParameterFile $parameterfile
            Write-Host ("Resource created: " +$name)
        }
    }