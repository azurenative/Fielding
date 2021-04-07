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

[create your first azure pipeline](https://docs.microsoft.com/en-us/azure/devops/pipelines/create-first-pipeline?view=azure-devops&tabs=java%2Ctfs-2018-2%2Cbrowser)



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
