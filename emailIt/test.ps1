#require version 3

. .\InvokeParseScript.ps1

$testScript = @'
function test {
    function x {
    }
}
'@

$r = Invoke-ParseScript $testScript

function LookupColor ($kind) {
    switch ($kind) {
        'Identifier' {'Red'}
        default      {'default'}
    }
}

function TagStuff {
    param(
        [Parameter(ValueFromPipeline)]
        $Token
    )

    Process {
        $token |
            add-member -passthru NoteProperty Color (LookupColor $Token.Kind)
    }
}

#$ast  = $r.ast
#$text = $r.ast.Extent.Text
#$list = $r.ListOfTokens | TagStuff
$r.ListOfTokens | TagStuff | ft