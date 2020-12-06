$Map = Get-Content .\Input.txt
$Width = $Map[0].Length
$Slopes = 
@(
	@{ Right = 1; Down = 1 },
	@{ Right = 3; Down = 1 },
	@{ Right = 5; Down = 1 },
	@{ Right = 7; Down = 1 },
	@{ Right = 1; Down = 2 }
)

$Part1 = (1..($Map.Count - 1) | Where-Object { $Map[$_][($_ * 3) % $Width] -eq '#' } | Measure-Object).Count

$Part2 = 1
$Slopes | ForEach-Object {
	$Right = $_.Right
	$Down = $_.Down
	$Part2 *= (1..([Math]::Floor(($Map.Count - 1) / $Down)) | Where-Object { $Map[$_ * $Down][($_ * $Right) % $Width] -eq '#' } | Measure-Object).Count
}

Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"