function getSeat([object[]]$State, [int]$Row, [int]$Col) {
	if ($Row -in 0..($State.Length-1) -and $Col -in 0..($State[0].Length-1)) {
		return $State[$Row][$Col]
	}
	else {
		return '.'
	}
}

function neighboursCount([object[]]$State, [int]$Row, [int]$Col) {
	$Neighbours = 0
	foreach ($i in ($Row-1)..($Row+1)) {
		foreach ($j in ($Col-1)..($Col+1)) {
			if ($i -ne $Row -or $j -ne $Col) {
				$Neighbour = getSeat -State $State -Row $i -Col $j
				if ($Neighbour -eq '#') {
					$Neighbours++
				}
			}
		}
	}
	return $Neighbours
}

function nextState([object[]]$State) {
	$NewState = @()
	foreach ($Row in 0..($State.Length-1)) {
		# Write-Host "Row: $Row"
		$RowArray = @()
		foreach ($Col in  0..($State[$Row].Length-1)) {
			$CurrentSeat = getSeat -State $State -Row $Row -Col $Col
			$NewSeat = $CurrentSeat
			if ($CurrentSeat -ne '.') {
				$Neighbours = neighboursCount -State $State -Row $Row -Col $Col
				if ($CurrentSeat -eq 'L' -and $Neighbours -eq 0) {
					$NewSeat = '#'
				}
				elseif ($CurrentSeat -eq '#' -and $Neighbours -ge 4) {
					$NewSeat = 'L'
				}
			}
			$RowArray += ,$NewSeat
		}
		# Write-Host "RowArray: $RowArray"
		$NewState += ,$RowArray
	}
	return $NewState
}

function occupiedSeats([object[]]$State) {
	return ($State | ForEach-Object { ($_ | Where-Object { $_ -eq '#' } | Measure-Object).Count } | Measure-Object -Sum).Sum
}

function drawState([object[]]$State) {
	foreach ($RowString in $State) {
		foreach ($ColString in $RowString) {
			Write-Host $ColString -NoNewline
		}
		Write-Host ""
	}
}

$InputState = Get-Content .\Input.txt
$State = @()
0..($InputState.Length-1) | ForEach-Object {
	$StringArray = $InputState[$_] -split '\s?' | Where-Object { $_ -ne '' }
	$State += ,$StringArray
}

$SameState = $false

do {
	Write-Host "Next State"
	# drawState -State $State
	$NewState = @()
	$NewState = nextState -State $State
	if ( -not (Compare-Object -ReferenceObject $State -DifferenceObject $NewState) ) {
		Write-Host "Found same state"
		$SameState = $true
	}
	$State = [object[][]]([System.Management.Automation.PSSerializer]::Deserialize([System.Management.Automation.PSSerializer]::Serialize($NewState,[int32]::MaxValue)))
} until ($SameState)

$Part1 = occupiedSeats -State $State

Write-Host "Part 1: $Part1"
# Write-Host "Part 2: $Part2"