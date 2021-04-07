#splatting rules  - just for fun
# deploy arm template with object parameters by Spl@tting
$DeploymentParameters = @{
    Name                    = "MyBicepDeployment0001"
    ResourceGroupName       = "rg-lga-001"
    Mode                    = "Incremental"
    TemplateFile            = ".\homerun\bicep\src\mainDeployment.bicep"
    TemplateParameterObject = @{
        location                       = "westeurope"
        logManagementResourceGroupName = "rg-lga-001"
        logAnalyticsName               = "la-wp-002"
    }
}

New-AzresourceGroupDeployment @DeploymentParameters


# deploy arm with templatefile and template parameters
New-AzresourceGroupDeployment -Name "MyBicepDeployment" `
    -ResourceGroupName "rg-lga-001" `
    -Mode Incremental `
    -TemplateFile ".\homerun\bicep\src\mainDeployment.bicep" `
    -TemplateParameterFile ".\homerun\bicep\src\parameters.arm..json"

#note not needed to build the bicep template to ARM when using powershell cmdlet .
