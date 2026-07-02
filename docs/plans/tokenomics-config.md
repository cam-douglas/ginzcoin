# GINZ Tokenomics Configuration

**Status:** Phase 0 locked; **human-confirmed 2026-06-23** — **≤$20 all-in launch cap**, **1M supply**, **~$20 FDV**  
**Role:** Locked numbers, addresses, and env var names. Process and audit checklist → [`ginz-token-roadmap.md`](ginz-token-roadmap.md) (canonical).

---

## Launch budget cap (locked)

**Maximum total spend: ~$20 USD all-in** (Base gas + USDC for LP combined).

| Item | Budget | Notes |
|------|--------|-------|
| Base gas (deploy, verify, distribute, pool, admin) | **~$10–12** | Defer Gnosis Safes at launch to stay in cap |
| USDC for Uniswap LP | **~$8** | Pairs with 400k GINZ (40% allocation) |
| **Total launch spend** | **≤ ~$20** | Hard planning cap |

**Phased option (still under $20):** deploy mainnet with trading off and **$0 LP** (~$10–12 gas only); add **~$8 USDC** pool when ready.

---

## Token identity

| Field | Value |
|-------|-------|
| Name | Ginzcoin |
| Symbol | GINZ |
| Decimals | 18 |
| Total supply | **1,000,000 GINZ** (`1_000_000 * 10**18` wei) |
| Minting | **Single mint at deploy (1M total); no public `mint()`** |

---

## Locked launch decisions

| Decision | Choice |
|----------|--------|
| Chain | Base mainnet (8453); test on Base Sepolia (84532) |
| LP quote asset | **USDC** |
| DEX | **Uniswap v3** (Base) |
| Contract toolchain | **Foundry** (Solidity ^0.8.24, OpenZeppelin v5) |
| Launch admin | **Owner EOA** (deployer hot wallet) through launch |
| Post-launch ownership | **Transfer to 2-of-3 Gnosis Safe** — do **not** renounce (see below) |
| **Launch capital cap** | **≤ ~$20 USD all-in (gas + LP)** |
| **Target FDV (at micro-LP)** | **~$20** |

---

## Target price & liquidity

### Primary target (~$20 FDV · ~$20 all-in spend)

| Metric | Value |
|--------|-------|
| **Total mint** | **1,000,000 GINZ** (fixed forever) |
| **Target FDV** | **~$20** |
| **Token price** | **$0.00002 per GINZ** (`$20 ÷ 1M`) |
| **GINZ in LP** (40% allocation) | **400,000 GINZ** |
| **USDC for LP** | **~$8 USDC** (`400k × $0.00002`) |

Formulas:

```
price     = FDV ÷ total_supply  →  $20 ÷ 1,000,000 = $0.00002
lp_usdc   = lp_ginz × price     →  400,000 × $0.00002 = $8
FDV check = price × total_supply → $0.00002 × 1M = $20
all_in    ≈ lp_usdc + gas       →  ~$8 + ~$10–12 ≈ $18–20
```

With 40% of supply in LP: **FDV ≈ 2.5 × USDC deposited** (same ratio at any supply).

### Total launch cost (human)

| Item | Est. cost |
|------|-----------|
| LP (400k GINZ + USDC) | **~$8 USDC** |
| Mainnet gas (lean path; Safes deferred) | **~$10–12** (Base ETH) |
| Testnet + build + Vercel | **$0** |
| Team vesting | **$0** (tokens only) |
| **Typical all-in launch** | **≤ ~$20 USD** |

### Optional: add LP depth later (raises FDV; extra spend)

| Extra USDC in pool | Total USDC (400k GINZ) | Spot price | FDV (1M) |
|--------------------|------------------------|------------|----------|
| — | **$8** | **$0.00002** | **~$20** |
| +$12 | $20 | $0.00005 | ~$50 |
| +$32 | $40 | $0.00010 | ~$100 |

**Do not** pair the full 1M supply into the pool — only the **400k LP allocation** (40%).

**Human confirms before mainnet LP:** deposit **~$8 USDC** + **400,000 GINZ** (within **~$20 all-in** cap including gas).

---

## Allocation

| Bucket | GINZ | % | Recipient | When |
|--------|------|---|-----------|------|
| Liquidity | 400,000 | 40% | Deployer EOA → Uniswap pool | Phase 5 (human) |
| Community / airdrops | 300,000 | 30% | Community wallet (TBD address) | Deploy script transfer |
| Treasury | 150,000 | 15% | Treasury Safe (2-of-3) or EOA at launch | After Safe created |
| Team | 150,000 | 15% | `TeamVesting.sol` | Deploy script transfer |

Wei amounts (18 decimals):

```
TOTAL_SUPPLY        =  1_000_000 ether
LIQUIDITY_AMOUNT    =    400_000 ether
COMMUNITY_AMOUNT    =    300_000 ether
TREASURY_AMOUNT     =    150_000 ether
TEAM_VESTING_AMOUNT =    150_000 ether
```

---

## Team vesting

### Beneficiary: **Team Safe (2-of-3 Gnosis Safe on Base)** — or EOA placeholder at micro launch

| Parameter | Value |
|-----------|-------|
| Beneficiary | Team Safe address (placeholder until created) |
| Start | `block.timestamp` at vesting contract deploy |
| Cliff | 365 days |
| Total vesting | 4 years (1y cliff + 3y linear after cliff) |
| Locked amount | **150,000 GINZ** |

**No USD required** — 150k GINZ transferred to vesting contract at deploy.

---

## Post-launch ownership

### Do not renounce ownership by default

| Phase | Owner | Actions |
|-------|-------|---------|
| Deploy → LP → launch | **Deployer EOA** | Distribute tokens, seed LP, `setExempt(pair)`, `enableTrading()` |
| 24–72h post-launch | **Deployer EOA** | Monitor; `removeLimits()` when ready |
| 7–14 days post-launch | **Deployer EOA → Operations Safe** | `transferOwnership(operationsSafe)` |

### Pre-ownership-transfer checklist

- [ ] LP locked/burned (tx published)
- [ ] `tradingActive == true`; limits policy executed
- [ ] **150k** in TeamVesting; **150k** in Treasury; **300k** in community wallet
- [ ] Pair + vesting + community exempt as needed
- [ ] Contract verified on Basescan

---

## Uniswap v3 on Base (reference)

| Contract | Address |
|----------|---------|
| USDC | `0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913` |
| Uniswap V3 Factory | `0x33128a8fC17869897dcE68Ed026d694621f6FDfD` |
| SwapRouter02 | `0x2626664c2603336E57B271c5C0b26F421741481` |
| NonfungiblePositionManager | `0x03a520b32C04BF3bEEf7BF5e5F322bd21bBEd062` |

Pool: **GINZ / USDC** — fee tier **0.30% (3000)** or **1% (10000)**.

---

## Anti-bot defaults (contract constants)

| Parameter | Value |
|-----------|-------|
| `maxTransactionAmount` | 1% of supply = **10,000 GINZ** |
| `maxWalletAmount` | 2% of supply = **20,000 GINZ** |
| `cooldownBlocks` | 0 (same-block double-buy prevention) |
| `tradingActive` | `false` at deploy |
| `limitsEnabled` | `true` at deploy |

**Exempt at deploy:** owner, vesting contract, community wallet.  
**Exempt before `enableTrading`:** Uniswap pair address.

---

## Environment variables (names only)

```bash
PRIVATE_KEY=
BASE_RPC_URL=
BASE_SEPOLIA_RPC_URL=
ETHERSCAN_API_KEY=
DEPLOYER_EOA=
TEAM_SAFE_ADDRESS=
TREASURY_SAFE_ADDRESS=
COMMUNITY_WALLET_ADDRESS=
GINZ_TOKEN_ADDRESS=
TEAM_VESTING_ADDRESS=
UNISWAP_PAIR_ADDRESS=
NEXT_PUBLIC_CHAIN_ID=8453
NEXT_PUBLIC_GINZ_ADDRESS=
NEXT_PUBLIC_WC_PROJECT_ID=
```

---

## Remaining human actions before deploy

- [x] Confirm token identity, allocation, **≤ ~$20 all-in** budget, **~$20 FDV** target (2026-06-23)
- [ ] Create Team Safe (2-of-3) on Base — or **EOA placeholder** to save gas under $20 cap
- [ ] Create Treasury Safe (2-of-3) on Base — or defer
- [ ] Designate community wallet
- [ ] Confirm **~$8 USDC** LP + gas fits **≤ ~$20 all-in** at mainnet LP step
- [ ] Fund deployer EOA with **~0.003–0.006 ETH** on Base (lean gas budget)

---

*Last updated: 2026-06-23 — **1M supply**; **≤ ~$20 all-in**; LP = 400k GINZ + ~$8 USDC → **~$20 FDV**.*
