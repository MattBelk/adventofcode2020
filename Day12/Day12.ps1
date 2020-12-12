using namespace System.Numerics

function SolvePart1($Instructions) {
	$Position = [Complex]::new(0,0)
	$Direction = 0
	
	$Instructions | ForEach-Object {
		$Action = $_.Substring(0,1)
		$Value = $_.Substring(1)
		if ($Action -eq 'F') {
			$Action = switch ($Direction) {
				0 { 'E' }
				90 { 'N' }
				180 { 'W' }
				270 { 'S' }
			}
		}

		switch ($Action) {
			N { $Position = [Complex]::Add($Position,[Complex]::new(0,$Value)) }
			E { $Position = [Complex]::Add($Position,[Complex]::new($Value,0)) }
			S { $Position = [Complex]::Add($Position,[Complex]::new(0,-$Value)) }
			W { $Position = [Complex]::Add($Position,[Complex]::new(-$Value,0)) }
			R { $Direction = ($Direction + 360 - $Value) % 360 }
			L { $Direction = ($Direction + 360 + $Value) % 360 }
		}
	} 
	return [Math]::Abs($Position.Real) + [Math]::Abs($Position.Imaginary)
}

function SolvePart2($Instructions) {
	$ShipPosition = [Complex]::new(0,0)
	$WaypointPosition = [Complex]::new(10,1)
	
	$Instructions | ForEach-Object {
		$Action = $_.Substring(0,1)
		$Value = $_.Substring(1)

		switch ($Action) {
			N { $WaypointPosition = [Complex]::Add($WaypointPosition,[Complex]::new(0,$Value)) }
			E { $WaypointPosition = [Complex]::Add($WaypointPosition,[Complex]::new($Value,0)) }
			S { $WaypointPosition = [Complex]::Add($WaypointPosition,[Complex]::new(0,-$Value)) }
			W { $WaypointPosition = [Complex]::Add($WaypointPosition,[Complex]::new(-$Value,0)) }
			F { $ShipPosition = [Complex]::Add($ShipPosition,[Complex]::new($WaypointPosition.Real*$Value,$WaypointPosition.Imaginary*$Value)) }
			default {
				switch ("$Action$Value") {
					{ $_ -in @("R270","L90") } { $WaypointPosition = [Complex]::Multiply($WaypointPosition,[Complex]::ImaginaryOne) }
					{ $_ -in @("R180","L180") } { $WaypointPosition = [Complex]::Negate($WaypointPosition) }
					{ $_ -in @("R90","L270") } { $WaypointPosition = [Complex]::Multiply([Complex]::Negate($WaypointPosition),[Complex]::ImaginaryOne) }
				}
			}
		}
	} 
	return [Math]::Abs($ShipPosition.Real) + [Math]::Abs($ShipPosition.Imaginary)
}

$Instructions = Get-Content .\Input.txt

$Part1 = SolvePart1 -Instructions $Instructions
$Part2 = SolvePart2 -Instructions $Instructions

Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"