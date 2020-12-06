function SeatID([string] $BoardingPass) {
	$Row = [convert]::ToInt32($($BoardingPass -replace '[RL]', '' -replace 'F', '0' -replace 'B', '1'), 2)
	$Column = [convert]::ToInt32($($BoardingPass -replace '[FB]', '' -replace 'L', '0' -replace 'R', '1'), 2)
	return ($Row * 8) + $Column
}

$BoardingPasses = Get-Content .\Input.txt
$SeatIDs = $BoardingPasses | ForEach-Object { SeatID -BoardingPass $_ }

$Part1 = ($SeatIDs | Measure-Object -Maximum).Maximum
$Part2 = ($SeatIDs | Where-Object { $_ + 1 -notin $SeatIDs -and $_ + 2 -in $SeatIDs }) + 1

Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"