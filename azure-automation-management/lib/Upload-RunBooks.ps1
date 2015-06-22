function Upload-RunBooks {
    param(
        [Parameter(Mandatory=$True)]
        [string]$StorageAccountName,

        [Parameter(Mandatory=$True)]
        [string]$ResourceGroupName,

        [ValidateScript({Test-Path $_ -Type "Container"})]
        [string]$RunBooksFolderPath,

        [string]$StorageContainerName = "automation"
    )

    Switch-AzureMode AzureResourceManager;

    $resourceGroup = Get-AzureResourceGroup -Name $ResourceGroupName;
    $storageAccount = New-AzureStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -Type Standard_LRS -Location $resourceGroup.Location;
    $storageAccountKey = (Get-AzureStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName).Key1;
    $storageContext = New-AzureStorageContext -StorageAccountKey $storageAccountKey -StorageAccountName $StorageAccountName;
    New-AzureStorageContainer -Context $storageContext -Name $StorageContainerName;
    
    $runbooks = Get-ChildItem $RunBooksFolderPath -Filter "*.ps1";
    $runbooks |% { Set-AzureStorageBlobContent -File $_ -Container $StorageContainerName -Context $storageContext }
}

if(!$MyInvocation.Line.Trim().StartsWith(". ")) {
    Upload-RunBooks -ResourceGroupName "CloudAutomation" -RunBooksFolderPath ".\run-books" -StorageContainerName "automation" -StorageAccountName "drautostore";
}