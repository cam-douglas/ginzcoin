# Ginzcoin frontend — Anvil smoke + Vercel

## Anvil smoke (Phase 3 verification)

### Prerequisites

- Foundry (`anvil`, `forge`, `cast`)
- `apps/web` built (`pnpm build`)

### Deploy contract locally

```bash
# Terminal 1
anvil --port 8545

# Terminal 2
cd contracts
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
export TEAM_SAFE_ADDRESS=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
export TREASURY_SAFE_ADDRESS=0x70997970C51812dc3A010C7d01b50e0d17dc79C8
export COMMUNITY_WALLET_ADDRESS=0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
```

Artifact: `deployments/31337.json`

### Frontend env

`apps/web/.env.local`:

```
NEXT_PUBLIC_CHAIN_ID=31337
NEXT_PUBLIC_GINZ_ADDRESS=<ginz from deploy log>
NEXT_PUBLIC_RPC_URL=http://127.0.0.1:8545
NEXT_PUBLIC_WC_PROJECT_ID=<walletconnect cloud id>
```

### Cast verification (2026-06-23)

Contract `0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0` on Anvil:

| Check | Result |
|-------|--------|
| `totalSupply()` | 1_000_000e18 |
| `tradingActive` (initial) | false |
| `limitsEnabled` (initial) | true |
| Non-owner `enableTrading` | reverted |
| Owner `enableTrading` | success |
| Owner `removeLimits` | success |

### UI checks

1. `/` — hero, GINZ ticker, tokenomics 40/30/15/15, on-chain stats
2. `/admin` account #0 — enable trading + remove limits
3. `/admin` account #1 — access denied
4. Wrong chain banner when wallet not on 31337

## Vercel deploy

**Live:** https://ginzcoin-web.vercel.app  
**Project:** `cam-douglas-projects/ginzcoin-web`

### Env matrix (dashboard or `scripts/vercel-env-setup.sh`)

| Env | `NEXT_PUBLIC_CHAIN_ID` | `NEXT_PUBLIC_GINZ_ADDRESS` |
|-----|------------------------|----------------------------|
| Preview | 84532 | Phase 4A Sepolia deploy |
| Production | 8453 | Phase 4B mainnet deploy |

## Files

- `apps/web/` — Next.js app
- `.github/workflows/web.yml` — lint, typecheck, build
- `contracts/foundry.toml` — `fs_permissions` for `deployments/`

## Validation status

- Local build: pass
- Anvil admin txs: pass (cast)
- Vercel live URL: **https://ginzcoin-web.vercel.app** (Ready, 2026-06-23)
- Vercel project: `cam-douglas-projects/ginzcoin-web`
- Env matrix set on Vercel (Preview: 84532, Production: 8453; GINZ=TBD until Phase 4A/4B)
