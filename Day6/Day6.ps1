$Groups = (Get-Content .\Input.txt -Raw) -Split "`r`n`r`n"

$Alphabet = 97..122 | ForEach-Object { [char]$_ }

$Part1 = ($Groups | ForEach-Object {
	$Group = $_
	($Alphabet | Where-Object { $Group.Contains($_) } | Measure-Object).Count
} | Measure-Object -Sum).Sum

$Part2 = ($Groups | ForEach-Object {
	$Group = $_
	($Alphabet | Where-Object { ([regex]$_).Matches($Group).Count -eq ($Group -Split "`r`n").Count } | Measure-Object).Count
} | Measure-Object -Sum).Sum

Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"