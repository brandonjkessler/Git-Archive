param(
    [string]$Path,
    [string]$Branch
)

$curLoc = Get-Location
set-location -Path $Path

$output = "..\"
$file = split-path ".\" -leaf

powershell.exe -ExecutionPolicy Bypass -Command "git archive --format=zip $Branch --output=$output\$file.zip -0 ."

Set-Location -Path $curLoc
