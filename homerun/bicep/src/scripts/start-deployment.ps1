#splatting rules  - just for fun
$BicepParameters = @{
    location                       = "westeurope"
    logManagementResourceGroupName = "rg-lga-001"
    logAnalyticsName               = "la-wp-001"
}

# deploy arm template with object parameters
New-AzresourceGroupDeployment -Name "MyBicepDeployment" `
    -ResourceGroupName "rg-lga-001" `
    -Mode Incremental `
    -TemplateFile ".\homerun\bicep\src\mainDeployment.bicep" `
    -TemplateParameterObject $BicepParameters

# deploy arm with template parameters
New-AzresourceGroupDeployment -Name "MyBicepDeployment" `
    -ResourceGroupName "rg-lga-001" `
    -Mode Incremental `
    -TemplateFile ".\homerun\bicep\src\mainDeployment.bicep" `
    -TemplateParameterFile ".\homerun\bicep\src\parameters.arm..json"
