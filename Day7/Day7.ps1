function GetContainingBags([string] $Bag) {
	$DirectlyContainingBags = $ContainedIn.$Bag
	$DirectlyContainingBags
	$DirectlyContainingBags | Where-Object { $_ -ne $null } | ForEach-Object { GetContainingBags -Bag $_ } | Select-Object -Unique
}

function GetNumberOfContainedBags([string] $Bag) {
	$Total = 0
	$Contains.$Bag.Keys | ForEach-Object {
		$Total += $Contains.$Bag.$_ 
		$Total += $Contains.$Bag.$_ * $(GetNumberOfContainedBags -Bag $_)
	}
	return $Total
}

$Rules = Get-Content .\Input.txt

$Contains = @{}
$ContainedIn = @{}
$Rules | ForEach-Object {
	$SplitRule = $_ -split " bags contain "
	$BagType = $SplitRule[0]
	$Contained = $SplitRule[1]
	if ($Contained -eq 'no other bags.' ) {
		$Contains.$BagType = @{}
	}
	else {
		$Contains.$BagType = @{}
		$Contained -replace " bags?\.?" -split ', '
		$Contained -replace " bags?\.?" -split ', ' | ForEach-Object {
			$SplitContained = $_ -split '(?<=\d) '
			$ContainedBagType = $SplitContained[1]
			$ContainedAmount = [int]$SplitContained[0]
			$Contains.$BagType.$ContainedBagType = $ContainedAmount
			[string[]]$ContainedIn.$ContainedBagType += $BagType
		}
	}
} | Out-Null

$Part1 = (GetContainingBags -Bag 'shiny gold' | Select-Object -Unique | Measure-Object).Count
$Part2 = GetNumberOfContainedBags -Bag 'shiny gold'

Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"