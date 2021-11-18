$targetAccountName = "DestAutomation"
$resourceGroupName = "Automation"
$scheduleName = "sche01"
$runbookName = "createTest"

#Login with Managed ID
Connect-AzAccount -Identity

#Create a Schedule
$StartTime = (Get-Date "13:00:00").AddDays(1)
[System.DayOfWeek[]]$WeekDays = @([SYstem.DayOfWeek]::Monday..[System.DayOfWeek]::Friday)
New-AzAutomationSchedule -AutomationAccountName $targetAccountName -Name $scheduleName -StartTime $StartTime -WeekInterval 1 -DaysOfWeek $WeekDays -ResourceGroupName $resourceGroupName

#Create a Runbook
New-AzAutomationRunbook -AutomationAccountName $targetAccountName -Name $runbookName -ResourceGroupName $resourceGroupName -Type PowerShell

#Publish a Runbook
Publish-AzAutomationRunbook -AutomationAccountName $targetAccountName -Name $runbookName -ResourceGroupName $resourceGroupName

#Link a Runbook to Schedule
Register-AzAutomationScheduledRunbook -RunbookName $runbookName -ScheduleName $scheduleName -ResourceGroupName $resourceGroupName -AutomationAccountName $targetAccountName -Debug