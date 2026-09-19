[CmdletBinding()]
param(
    [switch]$ConfirmDisposableTestnet,
    [string]$Binary = '.\\polygon-edge.exe'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $ConfirmDisposableTestnet) { 
    throw 'Refusing to run. Use -ConfirmDisposableTestnet; this creates 100 disposable local validators.'
}

$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$binaryPath = Join-Path $root $Binary
$workDir = Join-Path $root '.fem-testnet-100'
if (-not (Test-Path -LiteralPath $binaryPath -PathType Leaf)) {
    throw "Binary not found: $binaryPath. Build it first with Go."
}

if (Test-Path -LiteralPath $workDir) {
    Remove-Item -LiteralPath $workDir -Recurse -Force
}
New-Item -ItemType Directory -Path $workDir | Out-Null

& $binaryPath secrets init --insecure --data-dir (Join-Path $workDir 'validator-') --num 100
if ($LASTEXITCODE -ne 0) { throw 'Disposable validator key generation failed.' }

$bootnodes = [System.Collections.Generic.List[string]]::new()
for ($i = 1; $i -le 3; $i++) {
    $identity = & $binaryPath secrets output --data-dir (Join-Path $workDir "validator-$i")
    $nodeLine = $identity | Where-Object { $_ -match 'Node' } | Select-Object -First 1
    $nodeId = ([string]$nodeLine -split '\s+')[-1]
    if ([string]::IsNullOrWhiteSpace($nodeId)) { throw "Cannot read node ID for validator $i." }
    $bootnodes.Add('--bootnode')
    $bootnodes.Add("/ip4/127.0.0.1/tcp/$([int](31000 + $i))/p2p/$nodeId")
}

$genesis = Join-Path $workDir 'genesis.json'
$genesisArgs = @(
    'genesis', '--name', 'Fem Chain 100 Validator Testnet', '--chain-id', '23124001',
    '--consensus', 'ibft', '--ibft-validator-type', 'bls', '--validators-prefix', (Join-Path $workDir 'validator-'),
    '--block-gas-limit', '10000000', '--epoch-size', '1000',
    '--premine', '0x0000000000000000000000000000000000000001:1000000000000000000000000000',
    '--dir', $genesis
) + $bootnodes.ToArray()
& $binaryPath @genesisArgs
if ($LASTEXITCODE -ne 0) { throw '100-validator testnet genesis generation failed.' }

$pids = [System.Collections.Generic.List[int]]::new()
for ($i = 1; $i -le 100; $i++) {
    $arguments = @(
        'server', '--data-dir', (Join-Path $workDir "validator-$i"), '--chain', $genesis,
        '--grpc-address', ":$([int](11000 + $i))", '--libp2p', ":$([int](31000 + $i))",
        '--jsonrpc', "127.0.0.1:$([int](8500 + $i))", '--seal', '--log-level', 'WARN'
    )
    $process = Start-Process -FilePath $binaryPath -ArgumentList $arguments -WorkingDirectory $root -WindowStyle Hidden -RedirectStandardOutput (Join-Path $workDir "validator-$i.log") -RedirectStandardError (Join-Path $workDir "validator-$i.err.log") -PassThru
    $pids.Add($process.Id)
}
$pids | Set-Content -LiteralPath (Join-Path $workDir 'pids.txt')
Write-Output "STARTED=100"
Write-Output "WORKDIR=$workDir"
Write-Output 'RPC=http://127.0.0.1:8501'
