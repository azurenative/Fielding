$subscriptionId = "6dd0163e-bee5-44de-89dd-6a0853c8cf38"
$rg = "Networking.WestEurope.Jumpbox.Test"
$VmName = "SQN-AZPT-007"
$reportId
$url = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$rg/providers/Microsoft.Compute/virtualMachines/$VmName/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments?api-version=2020-06-25"
$reportUrl = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$rg/providers/Microsoft.Compute/virtualMachines/$VmName/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/WindowsDefenderExploitGuard/reports?api-version=2020-06-25"
$reportIdUrl = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$rg/providers/Microsoft.Compute/virtualMachines/$VmName/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/WindowsDefenderExploitGuard/reports/$reportId?api-version=2020-06-25"
$assessmentUrl="https://management.azure.com/subscriptions/$subscriptionId/providers/Microsoft.Security/assessments?api-version=2020-01-01"
$getassessment = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/Networking.WestEurope.Jumpbox.Test/providers/Microsoft.Compute/virtualMachines/SQN-AZPT-009/providers/Microsoft.Security/assessments/ffff0522-1e88-47fc-8382-2a80ba848f5d?api-version=2020-01-01"
$uri = "https://management.azure.com/subscriptions/$subscriptionId/providers/Microsoft.PolicyInsights/policyStates/latest/triggerEvaluation?api-version=2018-07-01-preview"
$azContext = Get-AzContext
$azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
$profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($azProfile)
$token = $profileClient.AcquireAccessToken($azContext.Tenant.Id)
$authHeader = @{
    'Content-Type'='application/json'
    'Authorization'='Bearer ' + $token.AccessToken
}
$context = Invoke-RestMethod -Method Post `
                            -Uri $uri `
                            -Headers $authHeader `
                            -Verbose `
                            -Debug
$context
$assessmentIds = $context.value
foreach($id in $assessmentIds)
{
    write-host "show this id:: $($id.id) name:: $($id.name)"
}

#assessment ID jumpbox  azpt-009 -- ffff0522-1e88-47fc-8382-2a80ba848f5d
#https://management.azure.com/{resourceId}/providers/Microsoft.Security/assessments/{assessmentName}?api-version=2020-01-01
$objects = $context.value
foreach($o in $objects)
{
    $o.id
}




Get-AzPolicyStateSummary
$initId = "/providers/Microsoft.Authorization/policyDefinitions/bed48b13-6647-468e-aa2f-1af1d3f4dd40"
get-azvmguestpolicystatus -ResourceGroupName $rg.ResourceGroupName `
                          -VMName $vm.Name -verbose -debug

Start-AzPolicyComplianceScan -ResourceGroupName 'Workload.WestEurope' -Verbose -Debug


