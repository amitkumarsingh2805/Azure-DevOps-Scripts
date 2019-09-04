#PLEASE NOTE THAT THIS TEMPLATE WORKS WITH WEBAPPS FOR WINDOWS OPERATING SYSTEM. For linux, linuxfxversion parameter should be added to the template files used.
#Note: please check the current stack and versions in the excel sheet if the values are provided properly. You may/may not specify the runtime value $rt
#webapp_list is a sample excel sheet added in directory for testing this script

#login to azure account and set context
Connect-AzAccount
Write-Host ("Connected to az account.")

#please enter your subscription ID to set context to current subscription
Set-AzContext -Subscription 'your subscription'
$subs= (Get-AzContext).Subscription
Write-Host ("subscription context is now set to: " +$subs)

# Access the excel sheet where the resources are provided
$excel_file_path = 'path of excel file'
$Excel= New-Object -ComObject Excel.Application
$Workbook= $Excel.Workbooks.Open($excel_file_path)
$WorkSheets= $WorkBook.WorkSheets
$WorkSheet= $WorkBook.Worksheets.Item(1)
Write-Host ("Successfully accessed workbook item: " +$WorkSheet)


#find the maximum row count for the number of filled rows
$intRowMax=$Worksheet.UsedRange.Rows.Count
Write-Host ("Calculated maximum number of filled rows in worksheet as: " +$intRowMax)

#loop to get the fields in the excel sheet and replace parameters in json

for($intRow=2; $intRow -le $intRowMax; $intRow++)
{   
#get contents of each cell
    $a=$WorkSheet.Cells.Item($intRow,5)
    $b=$WorkSheet.Cells.Item($intRow,6)
    $c=$WorkSheet.Cells.Item($intRow,7)
    #$d=$WorkSheet.Cells.Item($intRow,8)
    $e=$WorkSheet.Cells.Item($intRow,9)
    $f=$WorkSheet.Cells.Item($intRow,10)
    $g=$WorkSheet.Cells.Item($intRow,11)
    $h=$WorkSheet.Cells.Item($intRow,12)
   Write-Host ("Successfully collected all cells in row:" +$intRow)

#get only the text content of each cell and store in variable
    $Rn=$a.Text #resource name
    $rg=$b.Text #resource grp
    $stack=$c.Text #runtime stack###
    #$rt=$d.Text #runtime
    $asp=$e.Text #app service plan
    $reg=$f.Text  #Azure region
    $skucode= $g.Text  #sku code
    $sku=$h.Text #sku    
    Write-Host ("Successfully collected all parameters for app service:" +$Rn)

#if resource exists, print that it exists and do not create new resource
    if((Get-AzResource -Name $Rn -ResourceType Microsoft.Web/sites).Name -eq $Rn){
        Write-Host ("Resource with the given name exists: "+$Rn)
     }

#if resource does not exist, run the loop
    else{
        Get-AzResourceGroup -Name $rg -ErrorVariable notPresent -ErrorAction SilentlyContinue
        if ($notPresent)
        {
    
        # Do resource group deployment if resource group does not exist by creating new resource group and then create the resource
        Write-Host ("Resource group does not exist. Creating new resource group: " +$rg)
         New-AzResourceGroup -Name $rg -Location $reg
         Write-Host("Successfully created new resource group: " +$rg)
         New-AzResourceGroupDeployment -ResourceGroupName $rg -location $reg -hostingPlanName $asp -nameFromTemplate $Rn -sku $sku -skuCode $skucode -hostingEnvironment "" -serverFarmResourceGroup $rg -workerSize 0 -workerSizeId 0 -numberOfWorkers 1 -currentStack $stack -TemplateFile C:\Users\roopsa.d\Desktop\template\template.json -TemplateParameterFile C:\Users\roopsa.d\Desktop\template\parameters.json
         Write-Host ("Resource created: " +$Rn)
         break
        }

        else
        {
        # Do resource deployment only
        
            New-AzResourceGroupDeployment -ResourceGroupName $rg -location $reg -hostingPlanName $asp -nameFromTemplate $Rn -sku $sku -skuCode $skucode -hostingEnvironment "" -serverFarmResourceGroup $rg -workerSize 0 -workerSizeId 0 -numberOfWorkers 1 -currentStack $stack -TemplateFile C:\Users\roopsa.d\Desktop\template\template.json -TemplateParameterFile C:\Users\roopsa.d\Desktop\template\parameters.json
            Write-Host ("Resource created: " +$Rn)
        }
    }
}
        
$WorkBook.Save()
$Excel.Workbooks.Close()