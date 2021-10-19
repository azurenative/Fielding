<#
    .SYNOPSIS
    This script will remove all azure workbooks from a specific resource group.

    .PARAMETER csmParametersFile
    the arm template parameter file based on region deployment

    .PARAMETER subscriptionId
    the subscription id based on region deployment
#>


[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string] $csmParametersFile,
    

    [Parameter(Mandatory)]
    [string] $subscriptionId
)
try
{
  $parameterFile = Get-Content -Path $csmParametersFile -Raw | ConvertFrom-Json              
  Select-AzSubscription -Subscription $subscriptionId
  if(!$parameterFile)
  {
    Write-Error -message "the variable $parameterFile is empty" -verbose
  }              
  $workBooks = Get-AzResource -ResourceGroupName $parameterFile.parameters.logManagementResourceGroupName.value `
                              -ResourceType "microsoft.insights/workbooks"
  if(!$workBooks)
  {
      Write-Verbose -Message "[$($workBooks.Count)] workbooks found" -Verbose      
  }
  elseif($workBooks.count -ne 0)
  {
    foreach ($workBook in $workBooks)
    {
      $workbookResourceId = $workBook.ResourceId
      Write-Verbose -Message "deleting workbook [$($workbook.Name)]" 
      Remove-AzResource -ResourceId $workbookResourceId `
                        -Force `
                        -Verbose

      # get the workbook with current workbookresourceid
      $workBooks = Get-AzResource -ResourceId $workbookResourceId `
                                  -ErrorVariable workbookDeleted `
                                  -ErrorAction SilentlyContinue

      #to validate if workbook has been removed                                  
      $msg = $workbookDeleted[0].Exception.Message.contains("Not Found")
      if ($msg -and ($workBooks.count -eq 0)) {
          Write-Verbose -Message "Successfully removed workbook::[$($workBook.Name)]" -Verbose
      }
    }
  }
}
catch
{
    $errorMessage = $_.Exception.Message + "`nAt Line number: $($_.InvocationInfo.ScriptLineNumber)"
    throw $errorMessage

}