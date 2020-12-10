function GetAccumulator([Object[]]$Instructions) {
	$i = 0
	$Acc = 0
	$Visited = @{}
	while ($i -lt $Instructions.Length) {
		if ($Visited.$i) {
			# The program loops
			return $Acc, $false
		}
		else {
			$Instruction = $Instructions[$i]
			$Visited.$i = $true
			switch ($Instruction.Type) {
				jmp { $i += $Instruction.Argument }
				acc { $i++; $Acc += $Instruction.Argument }
				Default { $i++ }
			}
		}
	}
	# The program terminates, return $Acc
	return $Acc, $true
}

function GetFixedAccumulator([Object[]]$Instructions) {
	$i = 0
	$Visited = @{}
	while ($i -lt $Instructions.Length) {
		if ($Visited.$i) {
			# The program loops, break to get the full set of visited instructions
			break
		}
		else {
			$Instruction = $Instructions[$i]
			$Visited.$i = $true
			switch ($Instruction.Type) {
				jmp { $i += $Instruction.Argument }
				acc { $i++; }
				Default { $i++ }
			}
		}
	}

	foreach ($i in 0..($Instructions.Length-1) | Where-Object { $Visited.$_ -and $Instructions[$_].Type -ne "acc" }) {
		$FixedInstructions = ([System.Management.Automation.PSSerializer]::Deserialize([System.Management.Automation.PSSerializer]::Serialize($Instructions,[int32]::MaxValue)))
		$FixedInstructions[$i].Type = switch($FixedInstructions[$i].Type){
			jmp { "nop" }
			nop { "jmp" }
		}
		$Result = GetAccumulator -Instructions $FixedInstructions
		
		if ($Result[1]) {
			return $Result[0]
			break
		}
	}
}

$Instructions = Get-Content .\Input.txt | ForEach-Object { $SplitInstruction = $_ -split " "; @{ Type = [string] $SplitInstruction[0]; Argument = [int] $SplitInstruction[1]; } }

$Part1 = GetAccumulator -Instructions $Instructions | Select-Object -First 1
$Part2 = GetFixedAccumulator -Instructions $Instructions

Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"