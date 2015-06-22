param(

    [string]$AzureAutomationAccountName = "WorkstationsAutomation",
    [string]$ResourceGroupName = "CloudAutomation",
    [string]$ResourceGroupLocation = "West Europe",
    
    [string]$TemplateFilePath = "F:\Developer\azure-scripts\azure-automation-management\Templates\automation.json"

)

Switch-AzureMode AzureResourceManager;

. .\Create-AutomationResourceGroup.ps1;

$resourceGroup = Get-AzureResourceGroup |? { $_.ResourceGroupName -eq $ResourceGroupName };
if(!$resourceGroup) {
    $resourceGroup = Create-AutomationResourceGroup -ResourceGroupName $ResourceGroupName -ResourceGroupLocation $ResourceGroupLocation;
}

$Params = @{
    "accountName" = $AzureAutomationAccountName;
    "regionId" = $ResourceGroupLocation;
    "credentialName" = "DefaultAzureCredential";
	"userName" = "MyUserName"; 
	"password" = "MyPassword";
    "defaultSubscriptionVarName" = "DefaultSubscription";
    "defaultSubscription" = "BizSpark";
}


New-AzureResourceGroupDeployment -TemplateParameterObject $Params -ResourceGroupName $ResourceGroupName -TemplateUri $TemplateFilePath -Verbose;

