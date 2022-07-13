param(
[string]$id_key,
[string]$secret_key,
[string]$symbol,
[string]$side,
[string]$value
)
$orders = "https://api.alpaca.markets/v2/orders"
$Headers = @{
    'APCA-API-KEY-ID' = $id_key
    'APCA-API-SECRET-KEY' = $secret_key
}
$Body = @{
    'symbol' = $symbol
    'side' = $side
    'notional' = $value
    'type' = 'market'
    'time_in_force' = 'day'
}

$order = Invoke-RestMethod -Method Post -Uri $orders -Headers $Headers -Body ($Body | convertto-json)
$order