$Joltages = [int[]](Get-Content .\Input.txt) + 0 | Sort-Object
$Joltages += ($Joltages[$Joltages.Length-1] + 3)
$Differences = (1..($Joltages.Length - 1) | ForEach-Object { $Joltages[$_] - $Joltages[$_ - 1] })
# 1 Way to 'connect' 0 adapters, 1 to 'connect' 1, 1 to connect 2, 2 to connect 3, 4 for 4, 7 for 5...
$Permutations = @(1,1,1,2,4,7)

$Sequences = @()
$ConsecutiveNumbers = 1
foreach ($i in 0..($Joltages.Length-1)) {
	if($Joltages[$i+1] -ne $Joltages[$i]+1 -or $i -eq $Joltages.Length-1) {
		$Sequences += $ConsecutiveNumbers
		$ConsecutiveNumbers = 1
	}
	else {
		$ConsecutiveNumbers++
	}
}

$Part1 = 1
$Differences | Group-Object | Where-Object { $_.Name -in @(1,3) } | ForEach-Object { $Part1 *= $_.Count }
$Part2 = 1
$Sequences | ForEach-Object { $Part2 *= $Permutations[$_] }

Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"