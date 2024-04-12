param (
    # リソース グループ名
    [Parameter(Mandatory = $true)]
    [String]
    $resourceGroupName,

    # ストレージ アカウント名
    [Parameter(Mandatory = $true)]
    [String]
    $storageAccountName,

    # テーブル名
    # 指定がある場合はそのテーブルのみ、
    # 指定がない場合はすべての WAD テーブルを対象とする
    [String]
    $storageTableName = "",

    # ログの保持日数
    [int]
    $logRetentionDays = 365
)

#マネージド ID で Azure へログイン
Write-Output ("Connect Az Account...")
Connect-AzAccount -Identity

# システム時刻の取得
# Automation Runbook 内での Get-Date は UTC
# テーブル ストレージ Timestamp も UTC
$date = (Get-Date).AddDays(-1 * $logRetentionDays)
Write-Output ("====================================")
Write-Output ("Start (JST) : " + (Get-Date).AddHours(+9))
Write-Output ("====================================")
Write-Output ("DelPoint (UTC) : " + $date.ToString("yyyy-MM-ddTHH:mm:ss"))

# Tableストレージに接続
$sto = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName

# 引数にてテーブル名が指定されている場合はそのテーブルのみ取得
# 指定されていない場合、すべてのテーブルを取得
if ($null -eq $storageTableName) {
    # ストレージ アカウント内のすべての WAD テーブル取得
    $tbls = Get-AzStorageTable -Context $sto.Context
}
else {
    # 指定されたテーブルのみ取得
    $tbls = Get-AzStorageTable -Name $storageTableName -Context $sto.Context
}

# ストレージ内のテーブルごとに処理
foreach ($tbl in $tbls) {

    # テーブル取得
    $cld = $tbl.CloudTable
    Write-Output ("------------------------------------")
    Write-Output ("Table  : " + $cld)

    # WAD 関連テーブルでなければスキップ
    if ($cld.ToString().Substring(0, 3) -ne 'WAD') {
        Write-Output ("Skip the deletion process.")
        continue
    }

    try {
        # 指定日時よりタイムスタンプが古いエンティティを取得
        # 膨大なレコード数で時間がかかり過ぎないよう、最大 5000 件に制限
        # 必要に応じて調整
        Write-Output ("Get Entities...")
        $deleteQuery = "Timestamp le datetime'{0}'" -F $date.ToString("yyyy-MM-ddTHH:mm:ss")
        $rows = Get-AzTableRow -Table $cld -CustomFilter $deleteQuery -Top 5000
        Write-Output ("Target : " + $rows.Count)

        # 削除件数カウント用変数の初期化
        $del = 0

        #　対象レコード削除
        $null = $rows | Remove-AzTableRow -Table $cld
        $del = $rows.Count
        Write-Output ("Delete : " + $del)

        # 残エンティティの件数取得
        # $ents = Get-AzTableRow -Table $cld
        # $cnt = ($ents | measure).Count
        # Write-Output ("Remain : " + $cnt)
    }
    catch {
        # エラー発生時はエラー内容を出力
        # Powershellでは、発生した最新の例外は$error[0]に格納される。
        Write-Output ("An error occurred while processing " + $cld)
        Write-Output ("Error  : " + $error[0])
    }
}

Write-Output ("====================================")
Write-Output ("Finish (JST): " + (Get-Date).AddHours(+9))
Write-Output ("====================================")
