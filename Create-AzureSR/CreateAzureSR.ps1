# function for Select Contact Method
function selectContactMethod {
    # Create Form
    $contactMethodForm = New-Object System.Windows.Forms.Form
    $contactMethodForm.Size = New-Object System.Drawing.Size(450, 300)
    $contactMethodForm.Text = "サポートからの連絡方法"
    $contactMethodForm.StartPosition = "CenterScreen"

    # Create Group
    $contactMethodGroup = New-Object System.Windows.Forms.GroupBox
    $contactMethodGroup.Location = New-Object System.Drawing.Point(10, 10)
    $contactMethodGroup.size = New-Object System.Drawing.Size(125, 100)
    $contactMethodGroup.text = "連絡方法"

    # Create Radio Button
    # for Mail
    $mailButton = New-Object System.Windows.Forms.RadioButton
    $mailButton.Location = New-Object System.Drawing.Point(20, 25)
    $mailButton.size = New-Object System.Drawing.Size(80, 30)
    $mailButton.Checked = $True
    $mailButton.Text = "メール"

    # for Phone
    $phoneButton2 = New-Object System.Windows.Forms.RadioButton
    $phoneButton2.Location = New-Object System.Drawing.Point(20, 60)
    $phoneButton2.size = New-Object System.Drawing.Size(80, 30)
    $phoneButton2.Text = "電話"

    # Create OK Button
    $contactOkButton = new-object System.Windows.Forms.Button
    $contactOkButton.Location = New-Object System.Drawing.Point(55, 170)
    $contactOkButton.Size = New-Object System.Drawing.Size(80, 40)
    $contactOkButton.Text = "OK"
    $contactOkButton.DialogResult = "OK"

    # Create Cancel Button
    $contactCancelButton1 = new-object System.Windows.Forms.Button
    $contactCancelButton1.Location = New-Object System.Drawing.Point(145, 170)
    $contactCancelButton1.Size = New-Object System.Drawing.Size(100, 40)
    $contactCancelButton1.Text = "キャンセル"
    $contactCancelButton1.DialogResult = "Cancel"

    # Add Radio Button to Group
    $contactMethodGroup.Controls.AddRange(@($mailButton, $phoneButton2))

    # Add Controls to Form
    $contactMethodForm.Controls.AddRange(@($contactMethodGroup, $contactOkButton, $contactCancelButton1))

    # Set Accept Button and Cancel Button
    $contactMethodForm.AcceptButton = $contactOkButton
    $contactMethodForm.CancelButton = $contactCancelButton1

    # Always displayed in the foreground
    $contactMethodForm.TopMost = $True

    # Show Form
    $dialogResult = $contactMethodForm.ShowDialog()

    # Get Selected Method
    if ($dialogResult -eq "OK") {
        if ($mailButton.Checked) {
            $selectedMethod = "email"
        }
        elseif ($phoneButton2.Checked) {
            $selectedMethod = "phone"
        }
    }
    else {
        exit
    }

    return $selectedMethod
}

# function for Select Severity
function selectSeverity {
    # Creeate Form
    $severityForm = New-Object System.Windows.Forms.Form
    $severityForm.Size = New-Object System.Drawing.Size(400, 300)
    $severityForm.Text = "問合せの重要度"
    $severityForm.StartPosition = "CenterScreen"

    # Create Group
    $severityGroup = New-Object System.Windows.Forms.GroupBox
    $severityGroup.Location = New-Object System.Drawing.Point(10, 10)
    $severityGroup.size = New-Object System.Drawing.Size(125, 140)
    $severityGroup.text = "緊急度"

    # Create Radio Button
    $sevAButton = New-Object System.Windows.Forms.RadioButton
    $sevAButton.Location = New-Object System.Drawing.Point(20, 20)
    $sevAButton.size = New-Object System.Drawing.Size(80, 30)
    $sevAButton.Checked = $True
    $sevAButton.Text = "Sev.A (critical)"

    $sevBButton = New-Object System.Windows.Forms.RadioButton
    $sevBButton.Location = New-Object System.Drawing.Point(20, 60)
    $sevBButton.size = New-Object System.Drawing.Size(80, 30)
    $sevBButton.Text = "Sev.B (moderate)"

    $sevCButton = New-Object System.Windows.Forms.RadioButton
    $sevCButton.Location = New-Object System.Drawing.Point(20, 100)
    $sevCButton.size = New-Object System.Drawing.Size(80, 30)
    $sevCButton.Text = "Sev.C (minimal)"

    # Create OK Button
    $severityOKButton = new-object System.Windows.Forms.Button
    $severityOKButton.Location = New-Object System.Drawing.Point(55, 170)
    $severityOKButton.Size = New-Object System.Drawing.Size(80, 40)
    $severityOKButton.Text = "OK"
    $severityOKButton.DialogResult = "OK"

    # Create Cancel Button
    $severityCancelButton = new-object System.Windows.Forms.Button
    $severityCancelButton.Location = New-Object System.Drawing.Point(145, 170)
    $severityCancelButton.Size = New-Object System.Drawing.Size(100, 40)
    $severityCancelButton.Text = "キャンセル"
    $severityCancelButton.DialogResult = "Cancel"

    # Add Radio Button to Group
    $severityGroup.Controls.AddRange(@($sevAButton, $sevBButton, $sevCButton))

    # Add Controls to Form
    $severityForm.Controls.AddRange(@($severityGroup, $severityOKButton, $severityCancelButton))

    # Set Accept Button and Cancel Button
    $severityForm.AcceptButton = $severityOKButton
    $severityForm.CancelButton = $severityCancelButton

    # Always displayed in the foreground
    $severityForm.TopMost = $True

    # Show Form
    $dialogResult = $severityForm.ShowDialog()

    # Get Selected Severity
    if ($dialogResult -eq "OK") {
        if ($sevAButton.Checked) {
            $selectedSeverity = "critical"
        }
        elseif ($sevBButton.Checked) {
            $selectedSeverity = "moderate"
        }
        elseif ($sevCButton.Checked) {
            $selectedSeverity = "minimal"
        }
    }
    else {
        exit
    }

    return $selectedSeverity
}

# function for Input Discription
function inputDiscription {
    # Form
    $discriptionForm = New-Object System.Windows.Forms.Form
    $discriptionForm.Text = "問題の詳細"
    $discriptionForm.Size = New-Object System.Drawing.Size(600, 550)
    $discriptionForm.StartPosition = "CenterScreen"

    # Label
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(20, 20)
    $label.Size = New-Object System.Drawing.Size(340, 20)
    $label.Text = "問題の詳細を入力"
    $discriptionForm.Controls.Add($label)

    # Text Box
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Text = "▼解決したいこと `r`n`r`n▼問題の発生状況 `r`n`r`n▼エラーメッセージ `r`n`r`n▼確認したこと `r`n`r`n▼その他"
    $textBox.Location = New-Object System.Drawing.Point(20, 40)
    $textBox.Multiline = $True
    $textBox.AcceptsReturn = $True
    $textBox.AcceptsTab = $True
    $textBox.WordWrap = $True
    $textBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
    $textBox.Anchor = (([System.Windows.Forms.AnchorStyles]::Left) `
            -bor ([System.Windows.Forms.AnchorStyles]::Top) `
            -bor ([System.Windows.Forms.AnchorStyles]::Right) `
            -bor ([System.Windows.Forms.AnchorStyles]::Bottom))
    $textBox.Size = New-Object System.Drawing.Size(550, 350)
    $discriptionForm.Controls.Add($textBox)

    # OK Button
    $discriptionOkButton = New-Object System.Windows.Forms.Button
    $discriptionOkButton.Location = New-Object System.Drawing.Point(200, 420)
    $discriptionOkButton.Size = New-Object System.Drawing.Size(80, 40)
    $discriptionOkButton.Text = "OK"
    $discriptionOkButton.Anchor = (([System.Windows.Forms.AnchorStyles]::Right) `
            -bor ([System.Windows.Forms.AnchorStyles]::Bottom))
    $discriptionOkButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $discriptionForm.AcceptButton = $discriptionOkButton
    $discriptionForm.Controls.Add($discriptionOkButton)

    # Cancel Button
    $discriptionCancelButton = New-Object System.Windows.Forms.Button
    $discriptionCancelButton.Location = New-Object System.Drawing.Point(285, 420)
    $discriptionCancelButton.Size = New-Object System.Drawing.Size(80, 40)
    $discriptionCancelButton.Text = "Cancel"
    $discriptionCancelButton.Anchor = (([System.Windows.Forms.AnchorStyles]::Right) `
            -bor ([System.Windows.Forms.AnchorStyles]::Bottom))
    $discriptionCancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $discriptionForm.CancelButton = $discriptionCancelButton
    $discriptionForm.Controls.Add($discriptionCancelButton)

    # Always displayed in the foreground
    $discriptionForm.Topmost = $True

    # Activate the form and focus on text box
    $discriptionForm.Add_Shown({ $textBox.Select() })

    # Show Form
    $result = $discriptionForm.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        # Get Text Box Value if OK Button is clicked
        $inputedDiscription = $textBox.Text
    }
    return $inputedDiscription
}

# function for Create Contact Profile
function createContactProfile {
    # split additional email address if needed
    if ($additionalEmailAddress) {
        $additionalEmailAddressArray = $additionalEmailAddress.Split(":")

    }

    # Create Contact Profile
    if (!$additionalEmailAddress -and !$phoneNumber) {
        # Create Contact Profile without phone number and additional email address
        $contactProfile = New-AzSupportContactProfileObject -FirstName $firstName `
            -LastName $lastName `
            -PrimaryEmailAddress $emailAddress `
            -PreferredContactMethod $contactMethod `
            -Country $country `
            -PreferredSupportLanguage $language `
            -PreferredTimeZone $timeZone

    }
    elseif (!$additionalEmailAddress -and $phoneNumber) {
        # Create Contact Profile without additional email address
        $contactProfile = New-AzSupportContactProfileObject -FirstName $firstName `
            -LastName $lastName `
            -PrimaryEmailAddress $emailAddress `
            -PreferredContactMethod $contactMethod `
            -Country $country `
            -PreferredSupportLanguage $language `
            -PreferredTimeZone $timeZone `
            -PhoneNumber $phoneNumber

    }
    elseif ($additionalEmailAddress -and !$phoneNumber) {
        # Create Contact Profile without phone number
        $contactProfile = New-AzSupportContactProfileObject -FirstName $firstName `
            -LastName $lastName `
            -PrimaryEmailAddress $emailAddress `
            -PreferredContactMethod $contactMethod `
            -Country $country `
            -PreferredSupportLanguage $language `
            -PreferredTimeZone $timeZone `
            -AdditionalEmailAddress $additionalEmailAddressArray

    }
    elseif ($additionalEmailAddress -and $phoneNumber) {
        # Create Contact Profile with phone number and additional email address
        $contactProfile = New-AzSupportContactProfileObject -FirstName $firstName `
            -LastName $lastName `
            -PrimaryEmailAddress $emailAddress `
            -PreferredContactMethod $contactMethod `
            -Country $country `
            -PreferredSupportLanguage $language `
            -PreferredTimeZone $timeZone `
            -PhoneNumber $phoneNumber `
            -AdditionalEmailAddress $additionalEmailAddressArray
    }

    return $contactProfile
}

# function for Create Support Request
function createSupportTicket {
    # Create Contact Profile
    $contactProfile = createContactProfile

    # Create Support Request
    if (!$resourceId -and !$24By7Response) {
        # Create Support Ticket without resource ID and 24/7 Support
        New-AzSupportTicket -Name $ticketName `
            -Title $title `
            -CustomerContactDetail $contactProfile `
            -Description $description `
            -ProblemClassificationId $problemClassificationResourceId `
            -Severity $severity

    }
    elseif (!$resourceId -and $24By7Response) {
        # Create Support Ticket without resource ID, with 24/7 Support
        New-AzSupportTicket -Name $ticketName `
            -Title $title `
            -CustomerContactDetail $contactProfile `
            -Description $description `
            -ProblemClassificationId $problemClassificationResourceId `
            -Severity $severity `
            -Require24X7Response

    }
    elseif ($resourceId -and !$24By7Response) {
        # Create Support Ticket without 24/7 Support, with resource id
        New-AzSupportTicket -Name $ticketName `
            -Title $title `
            -CustomerContactDetail $contactProfile `
            -Description $description `
            -ProblemClassificationId $problemClassificationResourceId `
            -Severity $severity `
            -TechnicalTicketResourceId $resourceId

    }
    elseif ($resourceId -and $24By7Response) {
        # Create Support Ticket with 24/7 Support and resource id
        New-AzSupportTicket -Name $ticketName `
            -Title $title `
            -CustomerContactDetail $contactProfile `
            -Description $description `
            -ProblemClassificationId $problemClassificationResourceId `
            -Severity $severity `
            -TechnicalTicketResourceId $resourceId `
            -Require24X7Response

    }
}


# --- Initialize Common Variables ---
# Country Code
$country = "JPN"

# Language
$language = "ja-jp"

# Time Zone
$timeZone = "Tokyo Standard Time"

# Resource ID
$resourceId = ""

# Phone Number
$phoneNumber = ""

# Additional Email Address
$additionalEmailAddress = ""


# --- Load Assembly ---
[void][System.Reflection.Assembly]::Load("Microsoft.VisualBasic, Version=8.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


# --- Create Azure Support Request ---
# Login to Azure
Connect-AzAccount

# Select Subscription
$subscription = Get-AzSubscription | Out-GridView -OutputMode Single -Title "問合せ対象サブスクリプションの選択"

# Set Subscription
Set-AzContext -SubscriptionId $subscription.Id

# Input Last Name
$lastName = [Microsoft.VisualBasic.Interaction]::InputBox("ユーザーの姓を入力", "ユーザーの姓の入力")

# Input First Name
$firstName = [Microsoft.VisualBasic.Interaction]::InputBox("ユーザーの名を入力", "ユーザーの名の入力")

# Input Email Address
$emailAddress = [Microsoft.VisualBasic.Interaction]::InputBox("ユーザーのメールアドレスを入力", "メールアドレスの入力")

# Input Additional Email Address if needed
$isAdditionalEmailNeeded = [System.Windows.Forms.MessageBox]::Show("追加のメールアドレスが必要？", "追加メールアドレスの確認", "YesNo", "Question", "Button2")
if ($isAdditionalEmailNeeded -eq "Yes") {
    # Input Additional Email Address
    $additionalEmailAddress = [Microsoft.VisualBasic.Interaction]::InputBox("追加のメールアドレスをコロン ( : ) 区切りで入力", "追加メールアドレスの入力")
}

# Select Severity
$severity = selectSeverity
switch ($severity) {
    "critical" { $severityDisplayName = "Sev.A" }
    "moderate" { $severityDisplayName = "Sev.B" }
    "minimal" { $severityDisplayName = "Sev.C" }
    Default {}
}

# Select 24/7 Support if Severity is Sev.A
if ($severity -eq "critical") {
    # Turn On 24/7 Support Flag
    $24By7Response = $true

}
else {
    # Turn Off 24/7 Support Flag
    $24By7Response = $false

}

# Select Contact Method
$contactMethod = selectContactMethod

# Input Phone Number if Contact Method is Phone
if (($contactMethod -eq "phone") -or ($severity -eq "critical")) {
    # Input Phone Number
    $phoneNumber = [Microsoft.VisualBasic.Interaction]::InputBox("ユーザーの電話番号を入力", "電話番号の入力")
}

# Select Service Name
$serviceName = Get-AzSupportService | Out-GridView -OutputMode Single -Title "問合せ対象のサービス名を選択"
$serviceNameId = $serviceName.Name
$serviceNameDisplayName = $serviceName.DisplayName

# Select Problem Classification
$problemClassification = Get-AzSupportProblemClassification -ServiceName $serviceNameId | Out-GridView -OutputMode Single -Title "問題の種類とサブカテゴリの選択"
$problemClassificationId = $problemClassification.Name
$problemClassificationDisplayName = $problemClassification.DisplayName

# Get Problem Classification Resource ID
$problemClassificationResourceId = (Get-AzSupportProblemClassification -ServiceId $serviceNameId -id $problemClassificationId).id

# Input Title
$title = [Microsoft.VisualBasic.Interaction]::InputBox("問い合わせのタイトルを入力", "問い合わせタイトル")

# Input Discritption
$description = inputDiscription

# Input ResourceId
$resourceId = [Microsoft.VisualBasic.Interaction]::InputBox("問い合わせ対象のリソース ID を入力 `r`n(不要の場合は空欄のまま OK を選択)", "リソース ID の入力")

# Confirm Create Support Request
$isCreateAzureSR = [System.Windows.Forms.MessageBox]::Show("以下の内容で Azure サポート リクエストを作成する？
    姓 : $lastName
    名 : $firstName
    メールアドレス : $emailAddress
    追加メールアドレス : $additionalEmailAddress
    連絡方法 : $contactMethod
    電話番号 : $phoneNumber
    重要度 : $severityDisplayName
    24 時間 365 日のサポート対応 : $24By7Response
    タイトル: $title
    サービス名: $serviceNameDisplayName
    問題の種類とサブカテゴリ: $problemClassificationDisplayName
    対象リソース ID: $resourceId
    詳細: $description
    ", "サポート リクエストの作成確認", "YesNo", "Question", "Button2")

# Create Support Request
if ($isCreateAzureSR -eq "yes") {
    # trim space from title for ticket name
    $ticketName = $title.Replace(" ", "")
    $ticketName = $ticketName.Replace("　", "")

    # trim space from additional email address
    $additionalEmailAddress = $additionalEmailAddress.Replace(" ", "")
    $additionalEmailAddress = $additionalEmailAddress.Replace("　", "")

    # Create Support Request
    createSupportTicket

    # Get Created Support Request
    $createdSr = get-azsupportticket -name $ticketName

    # Show Result with SR Number
    [Microsoft.VisualBasic.Interaction]::InputBox("作成結果 `r`n 以下の SR 番号で作成完了", "サポート リクエストの作成結果", $createdSr.SupportTicketId)

}
else {
    # Show Result
    [System.Windows.Forms.MessageBox]::Show("作成せずに終了", "サポート リクエストの作成結果")
}
