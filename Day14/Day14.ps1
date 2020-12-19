function MaskedNumber([string]$Mask,[string]$BinaryNumber) {
	[char[]]$BinaryNumberArray = $BinaryNumber
	0..($Mask.Length-1) | Where-Object { $Mask[$_] -ne 'X' } | ForEach-Object { $BinaryNumberArray[$_] = $Mask[$_] }
	[string]$BinaryNumberArray -replace " "
}

function MaskedMemoryAddresses([string]$Mask,[string]$BinaryNumber) {
	[char[]]$BinaryNumberArray = $BinaryNumber
	0..($Mask.Length-1) | Where-Object { $Mask[$_] -ne '0' } | ForEach-Object { $BinaryNumberArray[$_] = $Mask[$_] }
	$Combinations = GetCombinations -BinaryNumberArray $BinaryNumberArray
	0..($Combinations.Length-1) | Where-Object { ($_+1) % 36 -eq 0  } | ForEach-Object { ,[string]$Combinations[($_-35)..$_] -replace " " }
}

function GetCombinations([char[]]$BinaryNumberArray) {
	$Combinations = @()
	if (($BinaryNumberArray | Where-Object { $_ -eq 'X' }).Length -eq 0) {
		$BinaryNumberArray
	}
	else {
		$FirstIndex = $BinaryNumberArray.IndexOf([char]'X')
		$ZeroCombination = ([System.Management.Automation.PSSerializer]::Deserialize([System.Management.Automation.PSSerializer]::Serialize($BinaryNumberArray,[int32]::MaxValue)))
		$OneCombination = ([System.Management.Automation.PSSerializer]::Deserialize([System.Management.Automation.PSSerializer]::Serialize($BinaryNumberArray,[int32]::MaxValue)))
		$ZeroCombination[$FirstIndex] = '0'
		$OneCombination[$FirstIndex] = '1'
		$Combinations += (GetCombinations -BinaryNumberArray $ZeroCombination)
		$Combinations += (GetCombinations -BinaryNumberArray $OneCombination)
	}
	$Combinations 
}

$Instructions = Get-Content .\Input.txt

function SolvePart1($Instructions) {
	$Memory = @{}
	$Bitmask = ""

	foreach ($Instruction in $Instructions) {
		if ($Instruction -like "mask*") {
			$Bitmask = $Instruction -replace "mask = "
		}
		else {
			$SplitInstruction = $Instruction -replace "mem\[" -split "] = "
			$Position = $SplitInstruction[0]
			$Value = MaskedNumber -Mask $Bitmask -BinaryNumber ([convert]::ToString($SplitInstruction[1],2)).PadLeft(36,'0')
			$Memory.($Position) = [convert]::ToInt64($Value,2)
		}
	}
	($Memory.Values | Measure-Object -Sum).Sum
}

function SolvePart2($Instructions) {
	$Memory = @{}
	$Bitmask = ""

	foreach ($Instruction in $Instructions) {
		if ($Instruction -like "mask*") {
			$Bitmask = $Instruction -replace "mask = "
		}
		else {
			$SplitInstruction = $Instruction -replace "mem\[" -split "] = "
			$Value = $SplitInstruction[1]
			$Positions = MaskedMemoryAddresses -Mask $Bitmask -BinaryNumber ([convert]::ToString($SplitInstruction[0],2)).PadLeft(36,'0')
			$Positions | ForEach-Object { $Memory.([convert]::ToInt64($_,2)) = $Value }
		}
	}
	($Memory.Values | Measure-Object -Sum).Sum
}

$Part1 = SolvePart1 -Instructions $Instructions
Write-Host "Part 1: $Part1"

$Part2 = SolvePart2 -Instructions $Instructions
Write-Host "Part 2: $Part2"