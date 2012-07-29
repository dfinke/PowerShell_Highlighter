#require version 3

$path   = Split-Path (Resolve-Path $MyInvocation.InvocationName)
$script = Resolve-Path (join-path $path ..\core\InvokeParseScript.ps1)

. $script

$script = @'
function test {
    param($y=2)
    $x = [Math]::Pow($y,3)
    1..10 | % { $_}
}
'@

$script = @'
function test {
}
'@

$r = Invoke-ParseScript $script
#$r.ListOfErrors | Out-String
$r.ListOfTokens | ft -a

#if(!$r.HasErrors) {
#    $r.ListOfTokens | ft -a
#} else {
#    $r.ListOfErrors
#}
