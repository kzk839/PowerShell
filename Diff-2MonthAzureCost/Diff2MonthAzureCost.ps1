#---- define variables ----
$apiVersion = "2023-11-01"
$fromDateTime = "T00:00:00+00:00"
$toDateTime = "T23:59:59+00:00"
# Grouping By : "resourceGroupName" or "resourceId"
$groupingBy = "resourceGroupName"
# Show Result : $true or $false
$showResult = $false
# Export Csv : $true or $false
$exportCsv = $true
$payloadTemplate = @{
	type       = "Usage"
	timeframe  = "Custom"
	timePeriod = @{
		from = "fromDate"
		to   = "toDate"
	}
	dataset    = @{
		granularity = "Daily"
		aggregation = @{
			totalCost = @{
				name     = "PreTaxCost"
				function = "Sum"
			}
		}
		grouping    = @(
			@{
				type = "Dimension"
				name = "groupingBy"
			}
		)
	}
} | ConvertTo-Json -Depth 3
#Error Handling
$ErrorActionPreference = "Stop"

#---- functions ----
function getMonthData ([int]$num, $monthYM) {
	#Get Month Data
	#num: 1 or 2
	#monthYM: YYYY/MM

	#get month first date
	$fromDate = Get-Date -Year $monthYM.Split('/')[0] -Month $monthYM.Split('/')[1] -Day 1 -Format "yyyy-MM-dd"
	$toDate = (Get-Date -Year $monthYM.Split('/')[0] -Month $monthYM.Split('/')[1] -Day 1).AddMonths(1).AddDays(-1).ToString("yyyy-MM-dd")

	#replace payload
	$payload = $payloadTemplate -replace "fromDate", "${fromDate}${fromDateTime}" -replace "toDate", "${toDate}${toDateTime}" -replace "groupingBy", $groupingBy

	Write-Host "Get Month${num} Data (${monthYM})..."

	#Get Month Data
	$monthRawData = Invoke-AzRestMethod -Method POST -Path $uri -Payload $payload

	Write-Host "Complete`n"

	#Get Month Cost Data : two-dimensional array
	$monthData = ($monthRawData.Content | ConvertFrom-Json).properties.rows

	return $monthData
}

#Add M1 Data To Result
function addM1DataToResult ($m1Data, $m1DiffedData) {
	Write-Host "Add M1 Data To Result..."

	$m1Data | ForEach-Object {
		#Object Properties
		# $_[0] : cost
		# $_[1] : billingPeriod
		# $_[2] : resourceGroup (may "", not $null) or resourceId
		# $_[3] : currency

		#Get M1 ResourceGroup Name, Cost, Currency
		$m1Cost = $_[0]
		$m1Id = $_[2]
		$m1Currency = $_[3]

		if ($m1DiffedData | Where-Object -Property $groupingBy -eq $m1Id) {
			#if $m1Id is already in $m1DiffedData, add M1 Cost to $m1DiffedData and calculate diff
			($m1DiffedData | Where-Object -Property $groupingBy -eq $m1Id)."Cost : ${m1YM}" += $m1Cost
			($m1DiffedData | Where-Object -Property $groupingBy -eq $m1Id)."Diff (${m1YM} - ${m2YM})" += $m1Cost
		}
		else {
			#if $m1Id is not in $m1DiffedData, add New Object to $m1DiffedData
			$m1DiffedData += New-Object PSObject -Property @{
				$groupingBy                = $m1Id
				"Cost : ${m1YM}"           = $m1Cost
				"Cost : ${m2YM}"           = 0
				"Diff (${m1YM} - ${m2YM})" = $m1Cost
				Currency                   = $m1Currency
			}
		}
	}

	Write-Host "Complete`n"

	return $m1DiffedData
}

#Add M2 Data To Result
function addM2DataToResult ($m2Data, $resultData) {
	Write-Host "Add M2 Data To Result..."

	$m2Data | ForEach-Object {
		#Object Properties
		# $_[0] : cost
		# $_[1] : billingPeriod
		# $_[2] : resourceGroup (may "", not $null) or resourceId
		# $_[3] : currency

		#Get M2 ResourceGroup Name, Cost, Currency
		$m2Cost = $_[0]
		$m2Id = $_[2]
		$m2Currency = $_[3]

		if ($resultData | Where-Object -Property $groupingBy -eq $m2Id) {
			#if $m2Id is already in $resultData, add M2 Cost to $resultData
			($resultData | Where-Object -Property $groupingBy -eq $m2Id)."Cost : ${m2YM}" += $m2Cost
			($resultData | Where-Object -Property $groupingBy -eq $m2Id)."Diff (${m1YM} - ${m2YM})" -= $m2Cost
		}
		elseif ($null -eq ($resultData | Where-Object -Property $groupingBy -eq $m2Id)) {
			#if $m2Id is not in $resultData, add New Object to $resultData
			$resultData += New-Object PSObject -Property @{
				$groupingBy                = $m2Id
				"Cost : ${m1YM}"           = 0
				"Cost : ${m2YM}"           = $m2Cost
				"Diff (${m1YM} - ${m2YM})" = 0 - $m2Cost
				Currency                   = $m2Currency
			}
		}
	}

	if ($groupingBy -eq "resourceGroupName") {
		#if groupingBy is resourceGroupName, change Name to Non-ResourceGroup Cost Name
		($resultData | Where-Object -Property ResourceGroupName -eq "").$groupingBy = "Non-ResourceGroup Cost"
	}

	Write-Host "Complete`n"

	return $resultData
}

# ---- main ----
Write-Host "Start Script`n"

#Login to Azure
Write-Host "Login to Azure..."
Connect-AzAccount | Out-Null
Write-Host "Complete`n"

#Select Subscription
Write-Host "Select Subscription..."
$subscription = Get-AzSubscription | Out-GridView -OutputMode Single -Title "対象サブスクリプションの選択"
$subscriptionId = $subscription.Id
Write-Host "Target Subscription: $($subscription.Name)`n"

# Set Subscription
Set-AzContext -SubscriptionId $subscriptionId | Out-Null

#Set Cost Management Uri
$uri = "/subscriptions/${subscriptionId}/providers/Microsoft.CostManagement/query?api-version=${apiVersion}"

# Get Month1 Data : two-dimensional array
$m1YM = [Microsoft.VisualBasic.Interaction]::InputBox( "比較対象となる年月 (M1) をスラッシュ区切りで指定`r`n例 : 2024/1`r`n出力結果は M1 - M2 で算出`r`n", "比較対象となる年月の指定")

# Get Month2 Data : two-dimensional array
$m2YM = [Microsoft.VisualBasic.Interaction]::InputBox( "比較元となる年月 (M2) をスラッシュ区切りで指定`r`n例 : 2024/2`r`n出力結果は M1 - M2 で算出`r`n`r`nM1 の指定 : ${m1YM}", "比較元となる月の指定")

#Get Month Data
$month1Data = getMonthData 1 $m1YM
$month2Data = getMonthData 2 $m2YM

#Define Result Data
$diffedData = @()

#Add M2 Data To Result
$m1Result = addM1DataToResult $month1Data $diffedData

#Add M1 Data To Result and Calculate Diff
$result = addM2DataToResult $month2Data $m1Result

#Show Result
if ($showResult) {
	Write-Host "Show Result`n"
	$result | Select-Object -Property $groupingBy, "Cost : ${m1YM}", "Cost : ${m2YM}", "Diff (${m1YM} - ${m2YM})", Currency `
	| Sort-Object -Property "Diff (${m1YM} - ${m2YM})" -Descending | Out-GridView -Title "月額料金の差額 (${m1YM} - ${m2YM})"
}

#Export Csv
if ($exportCsv) {
	#Export Result to CSV
	Write-Host "Export Csv to ${PSScriptRoot}\Diff2MonthAzureCost.csv`n"

	#Round Off Cost and Diff to the fifth decimal place
	$roundResult = @()
	$roundResult += $result | ForEach-Object {
		$_."Cost : ${m1YM}" = [Math]::Round($_."Cost : ${m1YM}", 4,[MidpointRounding]::AwayFromZero)
		$_."Cost : ${m2YM}" = [Math]::Round($_."Cost : ${m2YM}", 4,[MidpointRounding]::AwayFromZero)
		$_."Diff (${m1YM} - ${m2YM})" = [Math]::Round($_."Diff (${m1YM} - ${m2YM})", 4,[MidpointRounding]::AwayFromZero)
		$_
	}

	#Export Csv
	$roundResult | Select-Object -Property $groupingBy, "Cost : ${m1YM}", "Cost : ${m2YM}", "Diff (${m1YM} - ${m2YM})", Currency `
	| Sort-Object -Property "Diff (${m1YM} - ${m2YM})" -Descending | Export-Csv -Path "${PSScriptRoot}\Diff2MonthAzureCost.csv" -NoTypeInformation -Encoding UTF8
}

Write-Host "End Script"