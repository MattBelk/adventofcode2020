function ScanningErrorRate($Ticket, [Hashtable]$Fields) {
	$ErrorRate = 0
	foreach ($Value in $Ticket -split ",") {
		$ValidValue = $false
		foreach ($FieldRange in $Fields.Values) {
			if ($Value -in $FieldRange) {
				$ValidValue = $true
				break
			}
		}
		if (-not $ValidValue) {
			$ErrorRate += $Value
		}
	}
	$ErrorRate
}

function IsValidTicket($Ticket, [Hashtable]$Fields) {
	$Valid = $true
	foreach ($Value in $Ticket -split ",") {
		$ValidValue = $false
		foreach ($FieldRange in $Fields.Values) {
			if ($Value -in $FieldRange) {
				$ValidValue = $true
				break
			}
		}
		if (-not $ValidValue) {
			$Valid = $false
			break
		}
	}
	$Valid
}

function IsValidFieldPosition($Tickets, $FieldRange, $Position) {
	$Valid = $true
	foreach ($Ticket in $Tickets) {
		$Value = ($Ticket -split ",")[$Position]
		if ($Value -notin $FieldRange) {
			$Valid = $false
			break
		}
	}
	$Valid
}

$RulesAndTickets = Get-Content .\Input.txt
$RulesCount = $RulesAndTickets.IndexOf("")
$Rules, $YourTicket, $NearbyTickets = $RulesAndTickets[0..($RulesCount-1)], $RulesAndTickets[$RulesCount+2], $RulesAndTickets[($RulesCount+5)..($RulesAndTickets.Length-1)]

$Fields = @{}
foreach ($Rule in $Rules) {
	$SplitRule =  $Rule -split ": " -split " or " -split "-"
	$Fields.Add($SplitRule[0], ($SplitRule[1])..($SplitRule[2]) + ($SplitRule[3])..($SplitRule[4]))
}
$ValidTickets = (,$YourTicket + $NearbyTickets) | Where-Object { IsValidTicket -Ticket $_ -Fields $Fields }
 
$Part1 = ($NearbyTickets | ForEach-Object { ScanningErrorRate -Ticket $_ -Fields $Fields } | Measure-Object -Sum).Sum
Write-Host "Part 1: $Part1"

$PossiblePositions = @{}
$Positions = @{}
foreach($Field in $Fields.Keys) {
	$PossiblePositions.Add($Field, (0..($RulesCount-1) | Where-Object { IsValidFieldPosition -Tickets $ValidTickets -FieldRange $Fields.$Field -Position $_ }))
}

while ($Positions.Count -lt $RulesCount) {
	foreach ($Field in $Fields.Keys | Where-Object { $PossiblePositions.$_.Count -eq 1 }) {
		$Positions.$Field = $PossiblePositions.$Field
		Write-Host "$Field : $($PossiblePositions.$Field)"
		foreach ($OtherField in $Fields.Keys) {
			$PossiblePositions.$OtherField = $PossiblePositions.$OtherField | Where-Object { $_ -ne $Positions.$Field }
		}
	}
}

$DeparturePositions = 0..($RulesCount - 1) | Where-Object { $_ -in ($Positions.GetEnumerator() | Where-Object { $_.Key -like 'departure*' }).Value } 

$Part2 = ($YourTicket -Split ",")[$DeparturePositions] | Foreach-Object { $Product = 1 } { $Product *= $_ } { $Product }
Write-Host "Part 2: $Part2"