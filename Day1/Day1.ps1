$Part1 = $null
$Part2 = $null

$Numbers = Get-Content .\Input.txt | ForEach-Object { [int]$_ }

0..($Numbers.Count - 1) | ForEach-Object {
	$Number1 = $Numbers[$_]
	($_ + 1)..($Numbers.Count - 1) | ForEach-Object {
		$Number2 = $Numbers[$_]
		$Sum = $Number1 + $Number2
		if ($Sum -eq 2020) {
			$Part1 = $Number1 * $Number2
		}
		$Number3 = 2020 - $Sum
		if ($Numbers -contains $Number3) {
			$Part2 = $Number1 * $Number2 * $Number3
		}
	}
}

Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"