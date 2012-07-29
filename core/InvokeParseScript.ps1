#requires -version 3

function Invoke-ParseScript  {
    <#
    .Synopsis
        Uses PowerShell's parser and returns the AST, Tokens and Errors
    .Description
        Handles parsing PowerShell script files or strings.
        Uses the builtin System.Management.Automation.Language.Parser and returns
        an object that has the AST (Abstract Syntax Tree), raw tokens and errors.
        Plus, it adds to script properties that surfaces the tokens and errors
        in a specific format
    #>

    param(
        [Parameter(Mandatory)]
        [string]$Target
    )

    $method = "ParseInput"

    if(Test-Path $Target -ErrorAction SilentlyContinue) { $method = "ParseFile" }

    $parser = [System.Management.Automation.Language.Parser]
    $tokens = $null
    $errors = $null

    $CallSite = $parser::$method

    [PSCustomObject]@{
        AST    = $CallSite.Invoke(@($Target,[ref]$tokens,[ref]$errors))
        Tokens = $tokens
        Errors = $errors
    } |
        Add-Member -PassThru -MemberType ScriptProperty HasErrors { $this.Errors.Count -ge 1 } |
        Add-Member -PassThru -MemberType ScriptProperty ListOfTokens {
            ForEach($token in $this.Tokens) {
                $Extent = $token.Extent
                [PSCustomObject] @{
                    Text        = $token.Text
                    Kind        = $token.Kind
                    StartOffset = $Extent.StartOffset
                    EndOffset   = $Extent.EndOffset
                }
            }
        } |
        Add-Member -PassThru -MemberType ScriptProperty ListOfErrors {
            ForEach($scriptError in $this.Errors) {
                $Extent = $scriptError.Extent
                [PSCustomObject] @{
                    StartLineNumber   = $Extent.StartLineNumber
                    StartColumnNumber = $Extent.StartColumnNumber
                    Message           = $scriptError.Message
                }
            }
        }
}