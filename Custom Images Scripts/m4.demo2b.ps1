$images = Get-AzureRMResource -ResourceType Microsoft.Compute/images 
$images.name

Remove-AzureRmImage `
    -ImageName myOldImage `
    -ResourceGroupName myResourceGroup