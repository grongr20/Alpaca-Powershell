param(
[string]$id_key,
[string]$secret_key,
[string]$symbol,
[string]$time,
[string]$start
)
$stock = "https://data.alpaca.markets/v2/stocks/$symbol/bars?timeframe=$time&start=$start"
$Headers = @{
    'APCA-API-KEY-ID' = $id_key
    'APCA-API-SECRET-KEY' = $secret_key
}
$bars = Invoke-RestMethod -Method GET -Uri $stock -Headers $Headers
$bars