function ModularInverse($Number,$Modulus) {
	$Remainder = $Number % $Modulus
	foreach ($x in 1..($Modulus-1)) {
		if (($Remainder * $x) % $Modulus -eq 1) {
			return $x
		}
	}
	return 1
}

function SolvePart1($Notes) {
	$TimeStamp = $Notes[0]
	[int[]]$IDs = $Notes[1] -replace "x," -split ","
	
	$WaitingTimes = @{}
	foreach ($ID in $IDs) {
		$WaitingTimes.$ID = ($ID - $TimeStamp % $ID)
	}
	
	$ID = $WaitingTimes.Keys | Where-Object { $WaitingTimes.$_ -eq ($WaitingTimes.Values | Measure-Object -Minimum).Minimum }
	
	return  $ID * $WaitingTimes.$ID
}

function SolvePart2($Notes) {
	$Schedule = $Notes[1] -split ","
	$a = @()
	$n = @()
	$s = 0
	$Schedule | Where-Object { $_ -ne "x" } | ForEach-Object {
		# $a += $Schedule.IndexOf($_)
		$a += ($_ - $Schedule.IndexOf($_))
		$n += $_
	}
	$Product = $n | ForEach-Object { $Product = 1 } { $Product *= $_ } { $Product }
	foreach ($i in 0..($n.Length-1)) {
		$p = $Product / $n[$i]
		$s += $a[$i] * $p * (ModularInverse -Number $p -Modulus $n[$i])
	}
	# $Product - ($s % $Product)
	$s % $Product
}

$Notes = Get-Content .\Input.txt
$Part1 = SolvePart1 -Notes $Notes
$Part2 = SolvePart2 -Notes $Notes

Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"