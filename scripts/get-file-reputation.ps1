[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath,

    [string]$ReputationFile = (Join-Path $PSScriptRoot '..\examples\reputation.json')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $FilePath -PathType Leaf)) {
    throw 'The selected file does not exist.'
}
if (-not (Test-Path -LiteralPath $ReputationFile -PathType Leaf)) {
    throw 'The local reputation fixture does not exist.'
}

$manifestInfo = Get-Item -LiteralPath $ReputationFile
if ($manifestInfo.Length -gt 65536) {
    throw 'The local reputation fixture is too large.'
}

$manifest = Get-Content -LiteralPath $ReputationFile -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable
if ($manifest.schema -ne 1 -or $manifest.entries -isnot [System.Collections.IDictionary]) {
    throw 'The local reputation fixture has an invalid schema.'
}

foreach ($key in $manifest.entries.Keys) {
    if ($key -cnotmatch '^[a-f0-9]{64}$' -or $manifest.entries[$key] -isnot [string] -or
        $manifest.entries[$key].Length -gt 80) {
        throw 'The local reputation fixture has an invalid entry.'
    }
}

$hash = (Get-FileHash -LiteralPath $FilePath -Algorithm SHA256).Hash.ToLowerInvariant()
$label = $manifest.entries[$hash]
$displayLabel = if ($null -ne $label) { $label } else { 'No local fixture match' }

[pscustomobject]@{
    sha256 = $hash
    matched = ($null -ne $label)
    label = $displayLabel
    source = 'synthetic_local_fixture'
    uploaded = $false
}
