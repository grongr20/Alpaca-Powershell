param(
[string]$id_key,
[string]$secret_key,
[string]$symbol
)

$positions = "https://api.alpaca.markets/v2/positions/$symbol"
$Headers = @{
    'APCA-API-KEY-ID' = $id_key
    'APCA-API-SECRET-KEY' = $secret_key
}
Invoke-RestMethod -Method Get -Uri $positions -Headers $Headers