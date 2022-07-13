param(
[float]$entry,
[float]$current_price
)

del ./evaluation.txt

if($entry -lt $current_price * .98){
    "Sell" | Out-File -FilePath ./evaluation.txt
}
Else{
    "Hold" | Out-File -FilePath ./evaluation.txt
}