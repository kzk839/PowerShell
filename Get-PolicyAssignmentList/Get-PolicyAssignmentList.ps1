
$table = Get-AzPolicyAssignment | ForEach-Object{

    New-Object psobject -Property @{
        policyName = $_.Properties.DisplayName
        assignmentScope = $_.Properties.Scope
    }
}

$table | Format-Table
