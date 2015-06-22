function Create-AutomationResourceGroup {
    param(
    
        [Parameter(Mandatory=$True)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory=$True)]
        [string]$ResourceGroupLocation
    )

    Switch-AzureMode AzureResourceManager;

    Write-Output ("Creating resource group {0} in {1}" -f $ResourceGroupName, $ResourceGroupLocation);
    return New-AzureResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation;
}
