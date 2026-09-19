[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Manifest,

    [Parameter(Mandatory = $true)]
    [string]$Validators
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Fail([string]$Message) {
    throw "MAINNET PREFLIGHT FAILED: $Message"
}

if (-not (Test-Path -LiteralPath $Manifest -PathType Leaf)) { Fail "Manifest does not exist: $Manifest" }
if (-not (Test-Path -LiteralPath $Validators -PathType Leaf)) { Fail "Validator CSV does not exist: $Validators" }

$spec = Get-Content -LiteralPath $Manifest -Raw | ConvertFrom-Json
if ($spec.network.name -ne 'Fem Chain Mainnet') { Fail 'network.name must be Fem Chain Mainnet' }
if ($spec.network.symbol -ne 'FEM' -or [int]$spec.network.decimals -ne 18) { Fail 'native currency must be FEM with 18 decimals' }
if ([int]$spec.network.chainId -ne 23124) { Fail 'chain ID is not the approved value 23124' }
if ($spec.network.consensus -ne 'ibft' -or $spec.network.validatorType -ne 'bls') { Fail 'consensus must be IBFT with BLS validators' }
if (-not [bool]$spec.network.fixedSupply) { Fail 'mainnet must be fixed supply' }
if ([bool]$spec.network.initialBridgeEnabled) { Fail 'bridge must be disabled at genesis' }
if ([int]$spec.network.blockTimeSeconds -ne 2 -or [int]$spec.network.blockGasLimit -ne 10000000) { Fail 'unreviewed block parameters' }

$addressPattern = '^0x[0-9a-fA-F]{40}$'
$allocationSum = [Int64]0
$allocationAddresses = @{}
$buckets = @{}
foreach ($allocation in $spec.allocations) {
    if ([string]::IsNullOrWhiteSpace($allocation.bucket)) { Fail 'allocation bucket is empty' }
    if ($buckets.ContainsKey($allocation.bucket)) { Fail "duplicate allocation bucket: $($allocation.bucket)" }
    $buckets[$allocation.bucket] = $true
    if ($allocation.address -notmatch $addressPattern) { Fail "invalid allocation address for $($allocation.bucket)" }
    $normalized = $allocation.address.ToLowerInvariant()
    if ($allocationAddresses.ContainsKey($normalized)) { Fail "allocation address reused: $($allocation.address)" }
    $allocationAddresses[$normalized] = $true
    if ([Int64]$allocation.amountFem -le 0) { Fail "invalid allocation amount for $($allocation.bucket)" }
    $allocationSum += [Int64]$allocation.amountFem
}
if ($allocationSum -ne 1000000000) { Fail "allocation total is $allocationSum FEM; expected 1000000000" }

if ($spec.governance.governanceMultisig -notmatch $addressPattern) { Fail 'invalid governance multisig address' }
if ($spec.governance.threshold -ne '3-of-5' -or [int]$spec.governance.timelockHours -ne 48) { Fail 'unapproved governance threshold or timelock' }

$nodes = @(Import-Csv -LiteralPath $Validators)
if ($nodes.Count -ne 100) { Fail "validator count is $($nodes.Count); exactly 100 required" }
$seenAddresses = @{}
$seenBls = @{}
$seenPeers = @{}
$regions = @{}
$providers = @{}
foreach ($node in $nodes) {
    foreach ($field in @('node_label','region','provider','validator_address','bls_public_key','libp2p_peer_id','public_endpoint','operations_contact')) {
        if ([string]::IsNullOrWhiteSpace($node.$field) -or $node.$field.StartsWith('REPLACE_WITH_')) { Fail "missing $field for validator $($node.node_label)" }
    }
    if ($node.validator_address -notmatch $addressPattern) { Fail "invalid validator address for $($node.node_label)" }
    $address = $node.validator_address.ToLowerInvariant()
    if ($seenAddresses.ContainsKey($address)) { Fail "duplicate validator address: $($node.validator_address)" }
    if ($seenBls.ContainsKey($node.bls_public_key)) { Fail "duplicate BLS public key: $($node.node_label)" }
    if ($seenPeers.ContainsKey($node.libp2p_peer_id)) { Fail "duplicate libp2p peer ID: $($node.node_label)" }
    $seenAddresses[$address] = $true; $seenBls[$node.bls_public_key] = $true; $seenPeers[$node.libp2p_peer_id] = $true
    $regions[$node.region] = $true; $providers[$node.provider] = $true
}
if ($regions.Count -lt 5) { Fail "only $($regions.Count) regions; at least 5 required" }
if ($providers.Count -lt 3) { Fail "only $($providers.Count) providers; at least 3 required" }

Write-Host 'MAINNET PREFLIGHT PASSED'
Write-Host 'Supply: 1,000,000,000 FEM | Validators: 100 | Regions:' $regions.Count '| Providers:' $providers.Count
