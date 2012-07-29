#require version 3

$path   = Split-Path (Resolve-Path $MyInvocation.InvocationName)
$script = Resolve-Path (join-path $path ..\core\InvokeParseScript.ps1)

. $script

$testScript = @'
function test {
    param($y=2)
    $x = [Math]::Pow($y,3)
    1..10 | % { $_}
}
'@

$testScript = @'
function test {
    function x {
    }
}
'@

$r = Invoke-ParseScript $testScript

function TagStuff {
    param(
        [Parameter(ValueFromPipeline)]
        $Token
    )

    Begin {
        $ColorMap = @{
            'Identifier' = 'Red'
        }

        $LookupColor = {

            switch ($args[0]) {
                'Identifier' {'Red'}
                default      {'default'}
            }
        }
    }

    Process {

        $token |
            add-member -passthru NoteProperty Color (& $LookupColor $Token.Kind.ToString())

        #$color = $ColorMap.($Token.Kind.ToString())
        #if(!$color) {$color = 'default'}

        #$token |
        #    add-member -passthru NoteProperty Color $Color
    }
}

$r.ListOfTokens | TagStuff | ft