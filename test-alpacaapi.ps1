cd C:\alpaca-powershell

$key = get-content C:\alpaca-powershell\APIKEYID.txt
$secret = get-content C:\alpaca-powershell\APISECRET.txt

$approved_stocks = @("LOW", "AMZN", "KDP", "F", "AAPL", "TSLA", "KO", "PEP", "LANC", "PH", "HRL", "MMM")

for($z = 1; $z -gt 0; $z++){

#get basic account details
$account = .\get-alpacaaccount.ps1 $key $secret
$cash = $account.buying_power
$equity = $account.equity
$puchase = $true

Write-Host "---------------------------"
Write-Host "Available Funds: `$$cash"
Write-Host "Market Equity: `$$equity"


#get all of your positions together, chuck them to an evaluator, make a decision on b/s/h, then declare output
$positions = .\getall-alpacapositions.ps1 $key $secret

Write-Host "`n---------------------------"
WRITE-HOST "POSITIONS"
Write-Host "-------------------------------"
for($i = 0; $i -lt $positions.length; $i++){
    $symbol = $positions[$i].symbol
    $entry = $positions[$i].avg_entry_price
    $marketvalue = $positions[$i].market_value
    $current_price = $positions[$i].current_price
    
    $change_percent = ($current_price - $entry )/ $entry * 100
    $x = $i + 1

    Write-Host "Position $x $symbol"
    Write-Host "Entry: " $entry
    Write-Host "Market Value: " $marketvalue
    Write-Host "Current Price: " $current_price
    Write-Host "Change: $change_percent`%"
    ./evaluate-alpacaposition.ps1 $entry $current_price
    $evaluation = Get-content ./evaluation.txt
    if($evaluation -like "*Sell*"){
        Write-Host "Selling...."
        .\create-alpacaorder.ps1 $key $secret $symbol 'sell' $marketvalue
        Write-Host "Sold `$$marketvalue"
    }
    Else{
        Write-Host "Holding...`n"
    }
    sleep(1)
    Write-Host "-------------------------------"
}
sleep(3)
WRITE-HOST "BUYING CHOICES"
Write-Host "-------------------------------"

for($i = 0; $i -lt $approved_stocks.length; $i++){
    
    $date = [Xml.XmlConvert]::ToString(((get-date).AddMonths(-12)),[Xml.XmlDateTimeSerializationMode]::Utc)

    $stock = .\get-alpacastockbars.ps1 $key $secret $approved_stocks[$i] '12Months' $date

    $year_open = $stock.bars.o
    $year_now = $stock.bars.c
    $year_change =$year_open - $year_now
    $year_change_percent = $year_change / $year_open * 100
    $rounded = [math]::round($year_change_percent*100)/100
    write-host $approved_stocks[$i], " changed by ", $year_change, "or $rounded% over the year"

    $year_percent = $rounded

    $date = [Xml.XmlConvert]::ToString(((get-date).AddDays(-1)),[Xml.XmlDateTimeSerializationMode]::Utc)

    $stock = .\get-alpacastockbars.ps1 $key $secret $approved_stocks[$i] '1Day' $date

    $day_open = $stock.bars.o
    $day_now = $stock.bars.c
    $day_change =$day_open - $day_now
    $day_change_percent = $day_change / $day_open * 100
    $rounded = [math]::round($day_change_percent*100)/100
    write-host $approved_stocks[$i], " changed by ", $day_change, "or $rounded% over the day"

    $day_percent = $rounded

    if($year_percent -ge 12 -and $day_percent -le .5){
        $cash = $account.buying_power
        if($cash -le 3.5){
            $notional = 1
        }
        else{
            $notional = $cash / 2
        }
        Write-Host "Buying...."
        try{
            .\create-alpacaorder.ps1 $key $secret $approved_stocks[$i] 'buy' $notional
        }
        catch{
            Write-Host "Buy attempted; error returned. No purchase made"
            $purchase = $false
        }
        if($purchase -eq $true){
            Write-Host "Bought `$$notional"
        }
        $puchase = $true
    }
    else{
        Write-Host "No Buy"
    }
    sleep(1)
    Write-Host "`n-------------------------------`n"
}
sleep(10)
}