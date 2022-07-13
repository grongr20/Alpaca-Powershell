param(
[string]$id_key,
[string]$secret_key
)

$account = "https://api.alpaca.markets/v2/account"
$Headers = @{
    'APCA-API-KEY-ID' = $id_key
    'APCA-API-SECRET-KEY' = $secret_key
}
Invoke-RestMethod -Method Get -Uri $account -Headers $Headers