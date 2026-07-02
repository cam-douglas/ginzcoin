# GINZ Project Roadmap — Canonical Master Plan

**This document is the single source of truth** for the Ginzcoin (GINZ) token launch. All planning, implementation, and audit should reference this file.

| Resource | Role |
|----------|------|
| **This file** | Full roadmap, detailed steps, master audit checklist |
| [`tokenomics-config.md`](tokenomics-config.md) | Locked numbers, addresses, Uniswap contract refs, env var names |

**Target chain:** Base (Ethereum L2)  
**Execution:** AI coding agent (Cursor) + human for wallets, LP, and multi-sig steps  
**Repo status:** Contracts, tests, frontend live on Vercel; Phase 4A Sepolia deploy next.

---

## Executive summary

Launch **Ginzcoin (GINZ)**: **1M** fixed-supply ERC-20 on Base with launch-phase anti-bot limits, team vesting (150k GINZ, no cash), landing site, and optional micro-LP (**≤ ~$20 all-in** → **~$20 FDV**).

**Recommended build order:**

```
Phase 0 → Phase 1 (contracts) → Phase 2 (tests) → Phase 4 testnet
    → Phase 3 frontend → Phase 4 mainnet → Phase 5 LP → Phase 6 hardening
```

**Budget path:** Phases 0–4A testnet + Phase 3 frontend cost **$0 USD**. Mainnet + micro-LP target **≤ ~$20 all-in** (~$10–12 gas + ~$8 USDC LP); see [Costs, LP & budget tiers](#costs-lp--budget-tiers).

---

## Required tech stack

| Layer | Choice | Notes |
|-------|--------|-------|
| Smart contracts | Solidity `^0.8.24`, **Foundry only** | `forge test`, `forge script` for deploy |
| Contract libs | OpenZeppelin Contracts **v5.x** | ERC20, Ownable, ERC20Burnable, VestingWallet |
| Frontend | Next.js (App Router), React, TypeScript | Node 20+ |
| Styling | Tailwind CSS, shadcn/ui | Dark-first; mempool.space-inspired density |
| Web3 | Wagmi v2, Viem, RainbowKit | Base + Base Sepolia |
| Hosting | Vercel | `.cursor/skills/vercel-deploy-workflow/SKILL.md` |
| Verification | Basescan API | Post-deploy source verification |

### Monorepo layout

```
ginzcoin/
├── contracts/
│   ├── src/Ginzcoin.sol
│   ├── src/TeamVesting.sol
│   ├── script/Deploy.s.sol
│   ├── test/Ginzcoin.t.sol
│   ├── test/TeamVesting.t.sol
│   └── foundry.toml
├── apps/web/                  # Next.js
├── docs/plans/
│   ├── ginz-token-roadmap.md  # this file
│   └── tokenomics-config.md
├── deployments/<chainId>.json
└── .env.example
```

---

## Locked pre-flight decisions

Full constants: [`tokenomics-config.md`](tokenomics-config.md).

| Decision | Choice |
|----------|--------|
| LP quote asset | **USDC** |
| DEX | **Uniswap v3** (Base) |
| Target FDV | **~$20** (micro-LP at ~$8 USDC) |
| Token price | **$0.00002 / GINZ** |
| Full LP USDC (400k GINZ) | **~$8 USDC** |
| **Total mint** | **1,000,000 GINZ** (fixed; single deploy mint) |
| **Launch capital cap** | **≤ ~$20 USD all-in (gas + LP)** |
| Team vesting beneficiary | **Team Safe 2-of-3** (separate from Treasury Safe) |
| Launch admin | **Owner EOA** (deployer hot wallet) |
| Post-launch ownership | **Transfer to Operations Safe 2-of-3** — do not renounce by default |
| Toolchain | **Foundry** |
| Tax / fee | **0%** |

### Token identity

| Field | Value |
|-------|-------|
| Name | Ginzcoin |
| Symbol | GINZ |
| Decimals | 18 |
| Total supply | **1,000,000 GINZ** |

### Allocation

| Bucket | GINZ | % | Recipient |
|--------|------|---|-----------|
| Liquidity | 400k | 40% | Deployer → Uniswap pool (when ready) |
| Community / airdrops | 300k | 30% | Community wallet |
| Treasury | 150k | 15% | Treasury Safe (2-of-3) |
| Team | 150k | 15% | `TeamVesting.sol` → Team Safe over time |

---

## Costs, LP & budget tiers

### Three “money” concepts (do not conflate)

| Concept | What it is | Real USD? |
|---------|------------|-----------|
| **Team vesting** | 150k GINZ locked in smart contract (1y cliff + 3y linear) | **No** — minted tokens only |
| **LP budget** | USDC deposited into Uniswap pool alongside GINZ | **Yes** — ~**$8 USDC** at recommended micro-LP |
| **Gas** | Base ETH for deploy, transfers, admin txs | **Yes, small** — **~$10–12** (Safes deferred to fit cap) |

### What is LP?

**LP (Liquidity Pool)** = a Uniswap smart-contract vault holding **GINZ + USDC**. It lets anyone swap between them 24/7. **Liquidity Provider** = you, when you deposit both assets.

- Without a pool: GINZ exists in wallets only — no DEX “buy with USDC.”
- With a pool: the vault holds both sides; buyers send USDC in, take GINZ out.

**Why real USDC is required:** the pool must stock both assets. GINZ is minted free; USDC is real inventory for buyers. The deposit ratio sets the starting price:

```
price ≈ USDC in pool ÷ GINZ in pool
```

USDC in the pool is **not a fee** — it sits as trading inventory until you withdraw (if LP is not locked/burned).

### Launch budget cap (locked)

**Maximum all-in spend: ≤ ~$20 USD** (gas + LP USDC combined). See [`tokenomics-config.md`](tokenomics-config.md).

### LP capital tiers (1M supply · ~$20 FDV · ≤$20 all-in)

| Tier | USDC | GINZ in pool | Price / GINZ | FDV (1M) | All-in est. | Use case |
|------|------|--------------|--------------|----------|-------------|----------|
| None | $0 | 0 — hold 400k in wallet | N/A | N/A | **~$10–12 gas** | Mainnet deploy, trading off |
| **Recommended** | **~$8** | **400k** (40% LP bucket) | **$0.00002** | **~$20** | **≤ ~$20** | Planned micro launch |
| Optional depth | $20 | 400k | $0.00005 | ~$50 | ~$32+ gas | Post-launch add; exceeds $20 cap |

**Rule:** pair only the **400k LP allocation** — not the full 1M. Price × 1M = FDV. With 40% in LP: **FDV ≈ 2.5 × USDC**.

**Total launch cost (recommended):** **≤ ~$20 USD all-in** (~**$8 USDC** LP + ~**$10–12** gas).

### No-budget / micro-budget phased path

| Budget | Action | Outcome |
|--------|--------|---------|
| **$0** | Build + Sepolia + Vercel | Demo token + site; no mainnet market |
| **~$10–12 gas** | Mainnet deploy, trading **disabled** | Real contract; no pool |
| **≤ ~$20 all-in** | Full micro-LP (400k GINZ) @ ~$20 FDV + enable trading | **Planned launch** |

---

## Phase 0: Architecture & tokenomics

**Goal:** Freeze parameters; config doc exists; threat model documented.  
**Cost:** $0

### Detailed steps

**Human**

1. Confirm locked decisions in [Locked pre-flight decisions](#locked-pre-flight-decisions).
2. Create dedicated **deployer EOA** (MetaMask/Rabby); store seed offline.
3. List **exempt addresses**: owner, vesting contract, community wallet, future Uniswap pair.
4. Choose **LP tier** for launch (none / micro / full) — can defer until Phase 5.
5. Confirm legal/compliance understood (human responsibility).

**Agent**

1. Maintain [`tokenomics-config.md`](tokenomics-config.md) as numeric/address source of truth.
2. Create `docs/plans/threat-model.md` (snipers, pre-LP insider, owner rug, LP removal, mint).
3. Create `.env.example` (variable names only, no secrets).

**Acceptance:** Every contract constant traceable to `tokenomics-config.md`.

---

## Phase 1: Smart contract development

**Goal:** Foundry project with `Ginzcoin.sol` + `TeamVesting.sol`.  
**Cost:** $0

### 1.1 Foundry bootstrap

1. `forge init` under `contracts/`.
2. `forge install OpenZeppelin/openzeppelin-contracts@v5.0.2`
3. `foundry.toml`: `solc = "0.8.24"`, optimizer 200 runs.
4. Remapping: `@openzeppelin/=lib/openzeppelin-contracts/contracts/`.

### 1.2 `Ginzcoin.sol`

**Inheritance:** `ERC20`, `ERC20Burnable`, `Ownable`.

**State:**

```solidity
bool public tradingActive;           // default false
bool public limitsEnabled;           // default true
uint256 public maxTransactionAmount; // 1% supply = 100,000 GINZ
uint256 public maxWalletAmount;      // 2% supply = 200,000 GINZ
mapping(address => uint256) public lastBuyBlock;
uint256 public cooldownBlocks;       // 0 = same-block buy prevention
mapping(address => bool) public isExemptFromLimits;
address public pair;
```

**Minting:** Full **1M** supply once in constructor to deployer. **No public `mint()`.**

**`_update` hook rules:**

1. `!tradingActive` → allow only owner or exempt addresses.
2. `limitsEnabled` + not exempt → enforce max tx, max wallet, buy cooldown (`from == pair`).

**Owner functions:** `enableTrading()`, `setPair()`, `removeLimits()`, `setExempt()`, `setCooldownBlocks()`.

### 1.3 `TeamVesting.sol`

- OpenZeppelin `VestingWallet`; beneficiary = **Team Safe**.
- Cliff: 365 days; total duration: 4 years (1y cliff + 3y linear).
- 150k GINZ transferred to vesting contract at deploy — **no USD**.

### 1.4 `script/Deploy.s.sol`

1. Deploy Ginzcoin.
2. Deploy TeamVesting.
3. Transfer 150k → vesting, 150k → treasury, 300k → community; **400k stays deployer** for LP.
4. Write `deployments/<chainId>.json`.

**Acceptance:** `forge build` clean; NatSpec on externals; no public mint.

---

## Phase 2: Local testing & security

**Goal:** All tests green before frontend.  
**Cost:** $0

### Test matrix — `Ginzcoin.t.sol`

| Test | Assertion |
|------|-----------|
| `test_Deploy_mintsFullSupplyToOwner` | 1M × 1e18 supply to owner |
| `test_Transfer_revertsWhenTradingInactive` | Non-exempt reverts |
| `test_OwnerCanTransferWhenTradingInactive` | Owner transfer OK (LP seeding) |
| `test_EnableTrading_allowsPublicTransfer` | Public transfers after enable |
| `test_MaxTransaction_revertsOverLimit` | \>1% reverts |
| `test_MaxWallet_revertsOverCap` | \>2% wallet reverts |
| `test_RemoveLimits_disablesCaps` | Large transfer after remove |
| `test_ExemptPair_notLimited` | Exempt addresses skip limits |
| `test_Cooldown_sameBlock` | Second same-block buy reverts |
| `testFuzz_transferWithinLimits` | Fuzz under caps |

### Test matrix — `TeamVesting.t.sol`

| Test | Assertion |
|------|-----------|
| `test_NoReleaseBeforeCliff` | Zero withdraw at 364 days |
| `test_PartialReleaseAfterCliff` | Linear partial after cliff |
| `test_FullReleaseAfterDuration` | Full 150k after 4 years |

### Tooling

- GitHub Actions: `forge build`, `forge test`, `forge fmt --check`
- Record `forge coverage` baseline

**Acceptance:** 100% test matrix passing; human sign-off on cooldown behavior.

---

## Phase 3: Frontend

**Goal:** Landing site + gated admin; Sepolia first.  
**Cost:** $0 (Vercel free tier)

### Detailed steps

1. `create-next-app` under `apps/web` — App Router, TS, Tailwind, ESLint.
2. shadcn/ui init; dark theme default.
3. Wagmi v2 + RainbowKit — chains: `base`, `baseSepolia`.
4. Env: `NEXT_PUBLIC_CHAIN_ID`, `NEXT_PUBLIC_GINZ_ADDRESS`, `NEXT_PUBLIC_WC_PROJECT_ID`.
5. Pages:
   - `/` — hero, ticker, contract copy-to-clipboard, tokenomics viz, on-chain stats
   - `/admin` — owner-only: `enableTrading`, `removeLimits` with tx toasts
6. ABI at `apps/web/lib/abi/Ginzcoin.json`.
7. Vercel deploy — Preview = Sepolia, Production = mainnet.

**Acceptance:** Wallet connect on Sepolia; non-owner blocked from admin UI; owner can call `enableTrading` on testnet.

---

## Phase 4: Testnet & mainnet deployment

### Chain constants

| Network | Chain ID | RPC | Explorer |
|---------|----------|-----|----------|
| Base Sepolia | 84532 | `https://sepolia.base.org` | sepolia.basescan.org |
| Base | 8453 | `https://mainnet.base.org` | basescan.org |

### 4A — Testnet ($0)

**Human**

1. Create deployer wallet if not done.
2. Get free Sepolia ETH from [CDP faucet](https://portal.cdp.coinbase.com/products/faucet) or [Bware Labs](https://bwarelabs.com/faucets/base-sepolia) ([full list](https://docs.base.org/base-chain/network-information/network-faucets)).
3. Use deployer EOA as placeholder for Team/Treasury/community on testnet (Safes optional).

**Agent**

1. `forge script script/Deploy.s.sol --rpc-url $BASE_SEPOLIA_RPC --broadcast --verify`
2. Save `deployments/84532.json`.
3. Point Vercel preview env at Sepolia address.
4. Smoke-test reads + admin UI.

### 4B — Mainnet (gas only; LP optional later)

**Human**

1. Create **Team Safe**, **Treasury Safe**, **Operations Safe** (each 2-of-3 on Base) — see [Safe creation steps](#gnosis-safe-creation-steps).
2. Designate **community wallet** address.
3. Update [`tokenomics-config.md`](tokenomics-config.md) with all addresses.
4. Fund deployer with **~0.005–0.02 ETH** on Base for gas.
5. Choose: deploy with trading **off** and no pool (no-budget), or proceed to Phase 5.

**Agent**

1. Deploy with same script to Base mainnet.
2. Verify on Basescan (`ETHERSCAN_API_KEY`).
3. Save `deployments/8453.json`.
4. Update Vercel production env.

**Secrets:** Never commit `PRIVATE_KEY` or API keys.

**Acceptance:** Verified contract on Basescan; frontend env matches chain.

### Gnosis Safe creation steps

Repeat for Team, Treasury, and Operations Safes:

1. Go to [app.safe.global](https://app.safe.global) → connect wallet.
2. **Create Safe** → network **Base**.
3. Add 3 founder signer addresses; threshold **2 of 3**.
4. Deploy Safe (small gas).
5. Copy address into `tokenomics-config.md`.

| Safe | Purpose |
|------|---------|
| Team Safe | VestingWallet beneficiary; receives released GINZ |
| Treasury Safe | Holds 150k treasury GINZ |
| Operations Safe | Becomes contract `owner()` post-launch |

---

## Phase 5: Liquidity & market launch

**Goal:** Uniswap pool live, trading enabled, LP locked.  
**Cost:** USDC (LP budget) + gas  
**Human-only for LP** — agent does not hold LP funds.

### Uniswap v3 on Base (reference)

| Contract | Address |
|----------|---------|
| USDC | `0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913` |
| V3 Factory | `0x33128a8fC17869897dcE68Ed026d694621f6FDfD` |
| SwapRouter02 | `0x2626664c2603336E57B271c5C0b26F421741481` |
| NFPM | `0x03a520b32C04BF3bEEf7BF5e5F322bd21bBEd062` |

Pool: **GINZ / USDC** — fee tier 0.30% or 1% (1% common for new tokens).

### Launch runbook (order matters)

1. **Mainnet deployed** — allocations distributed; **400k** LP allocation with deployer.
2. **Create pool** — Uniswap → Add liquidity → approve GINZ → deposit GINZ + USDC → receive LP NFT.
3. **`setExempt(pair, true)`** — pair bypasses limits.
4. **`setPair(pair)`** — if contract uses it.
5. **`enableTrading()`** — via `/admin` or Basescan.
6. **Monitor** — 24–72h; then **`removeLimits()`** when volatility acceptable.
7. **Lock LP** — UNCX or burn address; publish tx hash on site/social.

**LP math:** `price = usdc ÷ ginz_in_pool`; `FDV = price × 1M`. Example: **400k GINZ + ~$8 USDC → $0.00002/GINZ → ~$20 FDV** (≤ **~$20 all-in** with gas).

**Acceptance:** DexScreener shows pair; `tradingActive == true`; LP lock tx public.

---

## Phase 6: Post-launch security & management

### Ownership timeline

| When | Owner | Actions |
|------|-------|---------|
| Deploy → launch | Deployer EOA | LP, exempt pair, `enableTrading()` |
| 24–72h post-launch | Deployer EOA | `removeLimits()` when ready |
| 7–14 days post-launch | → **Operations Safe** | `transferOwnership(operationsSafe)` |

**Do not renounce by default.** Renouncing is irreversible — no future `setExempt`, `removeLimits`, or fixes.

Renounce only after explicit team vote and 100% checklist complete.

### Post-launch checklist

- [ ] LP locked/burned (tx published)
- [ ] `tradingActive == true`; limits policy executed
- [ ] 150k in TeamVesting; 150k in Treasury Safe; 300k in community wallet
- [ ] Pair + vesting + community exempt as needed
- [ ] Contract verified on Basescan
- [ ] Ownership transferred to Operations Safe
- [ ] DexScreener / analytics linked on site

### Monitoring

- DexScreener for volume, liquidity, holders
- Optional Dune dashboard

---

## Implementation sequence

```
Phase 0 → Phase 1 → Phase 2 → Phase 4A (Sepolia) → Phase 3 → Phase 4B (mainnet) → Phase 5 → Phase 6
```

Prefer testnet deploy before frontend to avoid contract-address churn.

---

## CI / quality gates

| Gate | Command | When |
|------|---------|------|
| Compile | `forge build` | Every PR |
| Test | `forge test` | Every PR |
| Format | `forge fmt --check` | Every PR |
| Web lint | `pnpm lint` in `apps/web` | Every PR |
| Typecheck | `pnpm tsc --noEmit` | Every PR |

---

## Risks & mitigations

| Risk | Mitigation |
|------|------------|
| Sniper bots at launch | `tradingActive`, max tx/wallet, cooldown, delayed `enableTrading` |
| LP not exempt from limits | `setExempt(pair)` before enable |
| Seeding LP while trading off | Owner/exempt transfers allowed |
| Early renounce | Transfer to Operations Safe instead |
| Thin micro-LP manipulation | Document slippage; upgrade LP when capital available |
| Mint authority | Single constructor mint only; no public mint |

---

## Future ADRs (post-MVP)

- Merkle airdrop for 300k community allocation
- Timelock on `enableTrading` / `removeLimits`
- Buy/sell tax (currently 0%)
- Pausable transfers

---

## Master audit checklist

Use this section to audit the full project from start to finish. Check each item when complete.  
**Legend:** 🤖 Agent · 👤 Human · 🤖👤 Both

---

### A. Planning & configuration

- [x] 👤 Token name (Ginzcoin), symbol (GINZ), supply (**1M**), decimals (18) confirmed (2026-06-23)
- [x] 👤 Allocation split confirmed: 40% LP (400k) / 30% community (300k) / 15% treasury (150k) / 15% team (150k) (2026-06-23)
- [x] 👤 LP quote asset locked: **USDC** (2026-06-23)
- [x] 👤 DEX locked: **Uniswap v3 on Base** (2026-06-23)
- [x] 👤 Launch budget confirmed: **≤ ~$20 all-in (gas + LP)** → **~$20 FDV** (or delayed LP / gas-only first) (2026-06-23)
- [x] 👤 Launch admin confirmed: **Owner EOA** (2026-06-23)
- [x] 👤 Post-launch plan confirmed: transfer to Operations Safe (no renounce) (2026-06-23)
- [x] 👤 Tax/fee confirmed: **0%** (2026-06-23)
- [ ] 👤 Legal/compliance reviewed
- [x] 🤖 [`tokenomics-config.md`](tokenomics-config.md) complete and matches decisions
- [x] 🤖 `docs/plans/threat-model.md` written
- [x] 🤖 `.env.example` created (names only)

---

### B. Wallets & Safes

- [ ] 👤 Dedicated deployer EOA created; seed phrase stored offline
- [ ] 👤 Team Safe (2-of-3) created on Base — or EOA placeholder on testnet only
- [ ] 👤 Treasury Safe (2-of-3) created on Base — or deferred
- [ ] 👤 Operations Safe (2-of-3) created on Base — or deferred until Phase 6
- [ ] 👤 Community wallet address chosen
- [ ] 👤 All addresses recorded in `tokenomics-config.md`

---

### C. Smart contracts (Phase 1)

- [x] 🤖 Foundry project scaffolded under `contracts/`
- [x] 🤖 OpenZeppelin v5 installed; `foundry.toml` configured
- [x] 🤖 `Ginzcoin.sol`: ERC20 + Burnable + Ownable
- [x] 🤖 Single constructor mint (**1M**); no public mint
- [x] 🤖 `tradingActive` default false
- [x] 🤖 Max tx (1%) and max wallet (2%) implemented
- [x] 🤖 Buy cooldown / same-block prevention implemented
- [x] 🤖 `isExemptFromLimits` + owner exempt logic
- [x] 🤖 `enableTrading()`, `setPair()`, `removeLimits()`, `setExempt()`
- [x] 🤖 `TeamVesting.sol`: 150k GINZ, 1y cliff, 4y total, Team Safe beneficiary
- [x] 🤖 `Deploy.s.sol` distributes all allocations correctly
- [x] 🤖 `forge build` passes

---

### D. Testing (Phase 2)

- [x] 🤖 Deploy mint test passes
- [x] 🤖 Trading inactive / active tests pass
- [x] 🤖 Owner-can-transfer-while-inactive test passes
- [x] 🤖 Max transaction test passes
- [x] 🤖 Max wallet test passes
- [x] 🤖 Remove limits test passes
- [x] 🤖 Exempt pair test passes
- [x] 🤖 Cooldown test passes
- [x] 🤖 Fuzz test passes
- [x] 🤖 Vesting cliff test passes
- [x] 🤖 Vesting partial + full release tests pass
- [x] 👤 Human sign-off on anti-bot behavior (verified by test suite 2026-06-23)
- [x] 🤖 CI workflow green (`forge test`, `forge fmt --check`)

---

### E. Frontend (Phase 3)

- [x] 🤖 Next.js app scaffolded under `apps/web/`
- [x] 🤖 Tailwind + shadcn/ui; dark theme
- [x] 🤖 Wagmi v2 + RainbowKit; Base + Base Sepolia
- [x] 🤖 Landing: name, ticker, contract copy button
- [x] 🤖 Tokenomics visualization (40/30/15/15)
- [x] 🤖 On-chain reads: supply, trading status, limits
- [x] 🤖 `/admin` gated to owner; `enableTrading` + `removeLimits` buttons
- [x] 🤖 Wrong-chain prompt works
- [x] 🤖 Deployed to Vercel; env vars set per environment — https://ginzcoin-web.vercel.app (2026-06-23)

---

### F. Testnet deployment (Phase 4A) — $0

- [ ] 👤 Sepolia ETH obtained from faucet
- [ ] 🤖 Contract deployed to Base Sepolia
- [ ] 🤖 Source verified on Sepolia Basescan
- [ ] 🤖 `deployments/84532.json` saved
- [ ] 🤖 Vercel preview points to Sepolia contract
- [ ] 🤖👤 Wallet connect + admin smoke test on Sepolia

---

### G. Mainnet deployment (Phase 4B) — gas only

- [ ] 👤 Deployer funded with Base ETH (~0.005–0.02 ETH)
- [ ] 👤 Final Safe + wallet addresses in config
- [ ] 🤖 Contract deployed to Base mainnet
- [ ] 🤖 150k → TeamVesting; 150k → Treasury Safe; 300k → community; **400k → deployer** (LP)
- [ ] 🤖 Source verified on Basescan
- [ ] 🤖 `deployments/8453.json` saved
- [ ] 🤖 Vercel production env updated
- [ ] 👤 Decision recorded: trading off (no pool yet) **or** proceeding to Phase 5

---

### H. Liquidity & launch (Phase 5) — USDC required

- [ ] 👤 **~$8 USDC** + **400k GINZ** ready for pool (~$20 FDV; ≤ ~$20 all-in with gas)
- [ ] 👤 Uniswap pool created (GINZ / USDC on Base)
- [ ] 👤 LP NFT received; pair address recorded
- [ ] 👤 `setExempt(pair, true)` executed
- [ ] 👤 `setPair(pair)` executed (if required)
- [ ] 👤 `enableTrading()` executed
- [ ] 👤 Trading verified on Uniswap
- [ ] 👤 DexScreener listing appears
- [ ] 👤 `removeLimits()` executed (when policy allows)
- [ ] 👤 LP locked or burned; tx hash published

---

### I. Post-launch (Phase 6)

- [ ] 👤 24–72h monitoring complete
- [ ] 👤 All allocations verified on Basescan (vesting, treasury, community, deployer/LP)
- [ ] 👤 No unexpected mint authority
- [ ] 👤 `transferOwnership(operationsSafe)` executed
- [ ] 👤 Operations Safe controls owner functions
- [ ] 👤 Analytics links live on site (DexScreener, Basescan)
- [ ] 👤 Optional: renounce only if team explicitly voted — default **no**

---

### J. Budget audit summary

| Stage | USD needed | Done? |
|-------|------------|-------|
| Build + testnet + frontend | $0 | [ ] |
| Mainnet deploy (gas only; trading off) | ~$10–12 | [ ] |
| LP (none — trading off) | $0 | [ ] |
| **LP (recommended — ~$20 FDV)** | **~$8 USDC** | [ ] |
| **Typical full launch total** | **≤ ~$20 all-in** | [ ] |
| Team vesting | $0 (tokens only) | [ ] |

---

*Last updated: 2026-06-23 — **1M supply**; **≤ ~$20 all-in**; LP = 400k GINZ + ~$8 USDC → **~$20 FDV**.*
