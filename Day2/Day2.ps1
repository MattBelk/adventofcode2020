function isValidPasswordPart1([string] $Policy, [string] $Password) {
	$SplitPolicy = $Policy -Split ' '
	$Letter = $SplitPolicy[1]
	$Limits = $SplitPolicy[0] -Split '-'
	$LowerLimit = $Limits[0]
	$UpperLimit = $Limits[1]
	$Count = ($Password -Split $Letter).Count - 1
	if ($Count -ge $LowerLimit -and $Count -le $UpperLimit) {
		return $true
	}
	else {
		return $false
	}
}

function isValidPasswordPart2([string] $Policy, [string] $Password) {
	$SplitPolicy = $Policy -Split ' '
	$Letter = $SplitPolicy[1]
	$Limits = $SplitPolicy[0] -Split '-'
	$Position1 = $Limits[0]
	$Position2 = $Limits[1]
	if ($Password[$Position1 - 1] -eq $Letter -xor $Password[$Position2 - 1] -eq $Letter) {
		return $true
	}
	else {
		return $false
	}
}

$Passwords = Get-Content .\Input.txt

$Part1 = ($Passwords | Where-Object { isValidPasswordPart1 -Policy ($_ -Split ': ')[0] -Password ($_ -Split ': ')[1] }).Count
$Part2 = ($Passwords | Where-Object { isValidPasswordPart2 -Policy ($_ -Split ': ')[0] -Password ($_ -Split ': ')[1] }).Count

Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"