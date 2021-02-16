<#
    .SYNOPSIS
    Uses Git command line to export a Git repo.

    .DESCRIPTION
    Uses Git command line to export a Git repo.  
    Useful for removing bloat of .git folder.
    
    .PARAMETER Path
    Path to the Git repo. This will be the folder that has the .git folder below it.

    .PARAMETER Branch
    This is the branch from git you wish to archive from.
    
    .INPUTS
    Accepts inputs from pipeline that are Path or Branch

    .OUTPUTS
    None.

    .EXAMPLE
    Git-Archive -Path C:\Github\Some-Project -Branch Main

    .LINK
    
#>

param(
    [parameter(Mandatory,ValueFromPipelineByPropertyName,HelpMessage='Path to the folder that has the .git folder under it.')]
    [string]
    $Path,
    [parameter(Mandatory,ValueFromPipelineByPropertyName,HelpMessage='Branch of the git repo that you want to export.')]
    [string]
    $Branch
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
