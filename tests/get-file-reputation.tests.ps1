$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$script = Join-Path $root 'scripts/get-file-reputation.ps1'
$sample = Join-Path $root 'examples/sample.txt'
$fixture = Join-Path $root 'examples/reputation.json'

$result = & $script -FilePath $sample -ReputationFile $fixture
if (-not $result.matched) { throw 'The sample fixture should match.' }
if ($result.uploaded) { throw 'The script must never upload a file.' }
if ($result.source -ne 'synthetic_local_fixture') { throw 'Unexpected source.' }

$unknown = & $script -FilePath $script -ReputationFile $fixture
if ($unknown.matched) { throw 'An unknown file should not match.' }

$failed = $false
try { & $script -FilePath (Join-Path $root 'missing.file') -ReputationFile $fixture | Out-Null }
catch { $failed = $true }
if (-not $failed) { throw 'Missing files must be rejected.' }

Write-Output 'All local reputation checks passed.'
