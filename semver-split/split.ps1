param(
    [string] $Version
)
$Version -split '\.' | ForEach-Object -Begin { $str='' } -Process {
    if ($str -eq '') { 
        $str = $_
    } else {
        $str += ".$_"
    }
    $str
}
