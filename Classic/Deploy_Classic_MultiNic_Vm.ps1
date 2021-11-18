
Set-Azuresubscription - SubscriptionId "xxxxxx" -currentstorageaccountname classicsourcerg8180

$image = Get-AzureVMImage -ImageName "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-20190416-en.us-127GB.vhd"

$vm = New-AzureVMConfig -Name "ClassicVM05" -InstanceSize "Standard_A2_v2" -Image $image.ImageName

Add-AzureProvisioningConfig –VM $vm -Windows -AdminUserName "azureadmin" -Password "******"

Add-AzureNetworkInterfaceConfig -Name "Ethernet1" -SubnetName "subnet2" -StaticVNetIPAddress "10.0.1.50" -VM $vm

Set-AzureSubnet -SubnetNames "default" -VM $vm
Set-AzureStaticVNetIP -IPAddress "10.0.0.50" -VM $vm

New-AzureVM -ServiceName "kkcs05" -VNetName "Group Classic-Source-RG Classic-Source-VNet" -VMs $vm


