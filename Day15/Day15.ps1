function SolveDay15($StartingNumbers, $Limit) {
	$PreviouslySpoken = @{}
	0..($StartingNumbers.Length-1) | ForEach-Object { $PreviouslySpoken.($StartingNumbers[$_]) = $_ + 1 }

	$NumbersSpoken = $StartingNumbers.Length
	$PreviousNumber = $StartingNumbers | Select-Object -Last 1

	while ($NumbersSpoken -lt $Limit) {
		if (-not $PreviouslySpoken.("$PreviousNumber")) {
			$PreviouslySpoken.("$PreviousNumber") = $NumbersSpoken
			$PreviousNumber = 0
		}
		else {
			$TempPreviousNumber = $PreviousNumber
			$PreviousNumber = $NumbersSpoken - $PreviouslySpoken.("$PreviousNumber")
			$PreviouslySpoken.("$TempPreviousNumber") = $NumbersSpoken
		}

		$NumbersSpoken++
	}
	$PreviousNumber
}

$StartingNumbers = (Get-Content .\Input.txt) -split "," 

$Part1 = SolveDay15 -StartingNumbers $StartingNumbers -Limit 2020
Write-Host "Part 1: $Part1"

# $Part2 = SolveDay15 -StartingNumbers $StartingNumbers -Limit 30000000
# Write-Host "Part 1: $Part2"