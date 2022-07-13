$id_key = get-content C:\alpaca-powershell\APIKEYID.txt
$secret_key = get-content C:\alpaca-powershell\APISECRET.txt

$positions = "https://api.alpaca.markets/v2/assets"
$Headers = @{
    'APCA-API-KEY-ID' = $id_key
    'APCA-API-SECRET-KEY' = $secret_key
}
$arraytest = Invoke-RestMethod -Method Get -Uri $positions -Headers $Headers
$arraytest.symbol