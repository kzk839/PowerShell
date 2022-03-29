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
    # 指定がない場合はすべてのテーブルを対象とする
    [String]
    $storageTableName = "",

    # ログの保持日数
    [int]
    $logRetentionDays = 365
)

#マネージド ID で Azure へログイン
Connect-AzAccount -Identity

# システム時刻の取得
# テーブル ストレージ Timestamp は UTC
$date = (Get-Date).AddDays(-1 * $logRetentionDays)
Write-Output ("====================================")
Write-Output ("Start  : " + (Get-Date).AddHours(+9))
Write-Output ("====================================")
Write-Output ("DelPoint : " + $date.ToString("yyyy-MM-ddTHH:mm:ss"))

# Tableストレージに接続
$sto = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName

# 引数にてテーブル名が指定されている場合はそのテーブルのみ取得
# 指定されていない場合、すべてのテーブルを取得
if ($null -eq $storageTableName) {
    # ストレージ アカウント内のすべてのテーブル取得
    $tbls = Get-AzStorageTable -Context $sto.Context
}
else {
    # 指定されたテーブルのみ取得
    $tbls = Get-AzStorageTable -Name $storageTableName -Context $sto.Context
}

# ストレージ内のテーブルごとに処理
foreach ($tbl in $tbls) {

    # テーブル名取得
    $cld = $tbl.CloudTable
    Write-Output ("------------------------------------")
    Write-Output ("Table  : " + $cld)

    # 診断設定により作成されたテーブル以外はスキップ
    if ($cld.ToString().Substring(0, 3) -ne 'WAD') {
        Write-Output ("Skip the deletion process.")
        continue
    }

    try {
        # 指定日時よりタイムスタンプが古いエンティティを取得
        # 対象のレコード取得
        $deleteQuery = "Timestamp le datetime'{0}'" -F $date.ToString("yyyy-MM-ddTHH:mm:ss")
        $rows = Get-AzTableRow -Table $cld -CustomFilter $deleteQuery

        # 削除件数カウント用変数の初期化
        $del = 0

        #対象レコード削除
        $null = $rows | Remove-AzTableRow -Table $cld
        $del = $rows.Count
        Write-Output ("Delete : " + $del)

        # 残エンティティの件数取得
        # Measureオブジェクトにパイプで渡してCountプロパティを取得する。
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
Write-Output ("Finish : " + (Get-Date).AddHours(+9))
Write-Output ("====================================")
