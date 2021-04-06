# Fielding
this repository contains 101 training content on Azure, Bicep and Azure DevOps


## Strike ONE

1. Set up your VSCode (techstack and stuff)

2. Files and folder structure <>

3. Prepare and install bicep tools(bicep.exe and assemblies)

4. Fielding a bicep template (Start with your ARM not your Bicep!?!?)

5. Do i still need an arm template ???(decompile and play)

6. Let's do a deployment. (using powershell new-azresourcegroupdeployment)

### References:
[HowTo install Bicep tools](https://github.com/Azure/bicep/blob/main/docs/installing.md)

[Dwonload MSI for windows](https://github.com/Azure/bicep/blob/main/docs/installing.md#windows-installer)

[Official Azure Bicep Github](https://github.com/Azure/bicep)

[Bicep Syntaxes](https://build5nines.com/get-started-with-azure-bicep/#azure_bicep_files_and_syntax)

[VSCODE cheatsheet for Windows](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf)

[Markdown cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)

[Powershell C00l Spl@ting](https://adamtheautomator.com/powershell-splatting/)





#### Snippet from build5nines.com

## Azure Bicep Files and Syntax
Azure Bicep code is written in a simpler syntax that is easier to read and write than the JSON syntax used with ARM Templates.

The code syntax created for Azure Bicep shares some elements that you may already be familiar with in both JSON and YAML code.

The main element of Azure Bicep code is the resource block that declares an infrastructure resource to deploy. Here’s a simple example of Azure Bicep code that deploys an Azure Storage Account:

``` txt
  resource mystorage 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'bicepstorage2063'   // Globally unique storage account name
  location: 'northcentralus' // Azure Region
  kind: 'Storage'
  sku: {
    name: 'Standard_LRS'
  }
}
```
## Azure Resource Declaration Syntax
Declaring Azure resources with Azure Bicep code is done using the following format:

``` txt
resource <symbolic-name> '<type>@<api-version>` = {
  // Properties
  name: 'bicepstorage2063'
  location: 'northcentralus'
  sku: {
    name: "Standard_LRS'
  }
}
```
The different elements (as seen by the placeholders in the above example) of the Azure resource declaration in Azure Bicep code are as follows:

resource keyword – Use for declaring the block of code that defines Azure Resources to deploy
Symbolic name – This is an identifier (or name) within the Azure Bicep file that can be used to reference this resource in other locations within the bicep file.
Keep in mind, this is not the name of the Azure resource that is deployed; this name is only for referencing this resource within the Azure Bicep code.

Type – This is the Azure Resource Type name for the resource that is being declared. This is composed of the Azure Resource Provider name (such as Microsoft.Storage), and the resource type (such as storageAccounts).
The full Azure resource type value for an Azure Storage Account is Microsoft.Storage/storageAccounts.

API Version – After the Azure resource type, separated by an @ character, there needs to be an Azure Resource Provider apiVersion specified. This is a requirement that comes from Azure Resource Manager (ARM) and will be similar to the apiVersion specified in ARM Templates. For example, the API Version specified for an Azure Storage Account could be 2019-06-01.

Properties – The resource properties are contained within the = { ... } block within the resource declaration.

These will be the specific properties required for the specific Azure resource type declared.

All these properties will be the same properties required by an ARM Template when declaring the same Azure resource type.
The combination of the type and api version for the full Azure Resource Manager resource type that the resulting ARM Template will deploy.

Both of these values must be specified for all Azure resources declared within Azure Bicep code.

Keep in mind that the valid values to use here are the same as what’s accepted within ARM Templates.

As a result, Azure Bicep will automatically accept any valid ARM resource type and api version without any updated necessary for Azure Bicep to support it.
