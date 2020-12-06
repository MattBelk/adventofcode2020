$Passports = (Get-Content .\Input.txt -Raw) -Split "`r`n`r`n"

$RegexPart1 = '(?=[\s\S]*\bbyr)(?=[\s\S]*\biyr)(?=[\s\S]*\beyr)(?=[\s\S]*\bhgt)(?=[\s\S]*\bhcl)(?=[\s\S]*\becl)(?=[\s\S]*\bpid)'
$RegexPart2 = '(?=[\s\S]*\bbyr:(19[2-9][0-9]|200[0-2]))(?=[\s\S]*\biyr:(201[0-9]|2020)\b)(?=[\s\S]*\beyr:(202[0-9]|2030)\b)(?=[\s\S]*\bhgt:(((1[5-8][0-9]|19[0-3])cm)|(59|6[0-9]|7[0-6])in)\b)(?=[\s\S]*\bhcl:#[0-9a-f]{6}\b)(?=[\s\S]*\becl:(amb|blu|brn|gry|grn|hzl|oth)\b)(?=[\s\S]*\bpid:\d{9}\b)'

$Part1 = ($Passports | Where-Object { $_ -match $RegexPart1 } | Measure-Object).Count
$Part2 = ($Passports | Where-Object { $_ -match $RegexPart2 } | Measure-Object).Count

Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"