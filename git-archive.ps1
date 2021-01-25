param(
    [string]$Path,
    [string]$Branch
)

$curLoc = Get-Location
set-location -Path $Path

$output = "..\"
$file = split-path ".\" -leaf ## Name the file the same as the folder
$tag = (git tag -l) | sort-object -Descending ## Test for versions
if($null -eq $tag){ ## If no tags
    $file = split-path ".\" -leaf
} elseif(($tag[0].length) -lt 3) { ## if only one tag
    $file = "$(split-path ".\" -leaf)_" + "$($tag)"
} else { ## Multiple tags will name with the latest
    $file = "$(split-path ".\" -leaf)_" + "$($tag[0])"
}
powershell.exe -ExecutionPolicy Bypass -Command "git archive --format=zip $Branch --output=$output\$file.zip -0 ."

Set-Location -Path $curLoc
