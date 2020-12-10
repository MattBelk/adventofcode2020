$Numbers = Get-Content .\Input.txt | ForEach-Object { [bigint]$_ }
# $NumbersAsStrings = Get-Content .\Input.txt | ForEach-Object { [string]$_ }
$PreambleLength = 25

function IsSumOfPrevious([int]$Position) {
	$Sum = $Numbers[$Position]
	foreach ($Number in $Numbers[($Position - $PreambleLength)..($Position - 1)]) {
		if ($Sum - $Number -in ($Numbers[($Position - $PreambleLength)..($Position - 1)] | Where-Object { $_ -ne $Number })) {
			return $true
		}
		# Write-Host "Looking for: $($Sum-$Number)"
		# $Numbers[($Position-5)..($Position-1)] | Where-Object { $_ -ne $Number }
		# Write-Host ""
	}
}
function GetEncryptionWeakness([bigint]$Sum) {
	foreach ($LowerIndex in 1..($Numbers.Length-1) | Where-Object { $Numbers[$_] -lt $Sum } ) {
		Write-Host "Current LowerIndex: $LowerIndex"
		$UpperIndex = ($LowerIndex + 1)..($Numbers.Length-1) | Where-Object { ($Numbers[$LowerIndex..$_] | Measure-Object -Sum).Sum -eq $Sum }
		if ($UpperIndex) {
			Write-Host "Lower: $LowerIndex"
			Write-Host "Upper: $UpperIndex"
			$Measures = $Numbers[$LowerIndex..$UpperIndex] | Measure-Object -Minimum -Maximum
			Write-Host "Lowest Number: $($Measures.Minimum)"
			Write-Host "Highest Number: $($Measures.Maximum)"
			return $Measures.Minimum + $Measures.Maximum
		}
	}
}

$Part1Index = ($PreambleLength)..($Numbers.Length-1) | Where-Object { -not (IsSumOfPrevious -Position $_) } | Select-Object -First 1
$Part1 = $Numbers[$Part1Index]
$Part2 = GetEncryptionWeakness -Sum $Part1

Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"