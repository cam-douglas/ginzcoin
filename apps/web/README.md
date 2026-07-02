# Ginzcoin web app

Next.js landing site and owner-gated `/admin` for the GINZ token on Base.

## Setup

```bash
cd apps/web
pnpm install
cp .env.local.example .env.local
# Fill NEXT_PUBLIC_GINZ_ADDRESS and NEXT_PUBLIC_WC_PROJECT_ID
```

## Scripts

| Command | Purpose |
|---------|---------|
| `pnpm dev` | Dev server (http://localhost:3000) |
| `pnpm build` | Production build |
| `pnpm lint` | ESLint |
| `pnpm typecheck` | TypeScript (`tsc --noEmit`) |

## Environment

| Variable | Description |
|----------|-------------|
| `NEXT_PUBLIC_CHAIN_ID` | `31337` (Anvil), `84532` (Base Sepolia), `8453` (Base) |
| `NEXT_PUBLIC_GINZ_ADDRESS` | Deployed Ginzcoin contract |
| `NEXT_PUBLIC_WC_PROJECT_ID` | WalletConnect Cloud project ID |
| `NEXT_PUBLIC_RPC_URL` | Optional RPC override (Anvil default: `http://127.0.0.1:8545`) |

## Anvil smoke test

Terminal 1 — local chain:

```bash
anvil
```

Terminal 2 — deploy (Anvil account #0 key):

```bash
cd contracts
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
```

Copy the `Ginzcoin` address from output into `apps/web/.env.local`:

```
NEXT_PUBLIC_CHAIN_ID=31337
NEXT_PUBLIC_GINZ_ADDRESS=0x...
NEXT_PUBLIC_RPC_URL=http://127.0.0.1:8545
NEXT_PUBLIC_WC_PROJECT_ID=<your-wc-id>
```

Terminal 3 — frontend:

```bash
cd apps/web && pnpm dev
```

### Verify

Use distinct treasury/community addresses (deployer-only defaults fail the LP balance assert):

```bash
export TEAM_SAFE_ADDRESS=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
export TREASURY_SAFE_ADDRESS=0x70997970C51812dc3A010C7d01b50e0d17dc79C8
export COMMUNITY_WALLET_ADDRESS=0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
```

1. Landing shows supply 1M GINZ, trading not active, limits enabled.
2. `/admin` with account #0 (owner): Enable trading + Remove limits succeed.
3. `/admin` with account #1: Access denied, no action buttons.
4. Wrong network: switch MetaMask away from Anvil → banner appears; admin txs disabled.

## ABI sync

After contract changes, re-copy the ABI:

```bash
node -e "const a=require('../../contracts/out/Ginzcoin.sol/Ginzcoin.json'); require('fs').writeFileSync('lib/abi/Ginzcoin.json', JSON.stringify(a.abi, null, 2))"
```

Run from `apps/web/`.

## Vercel

- **Live:** https://ginzcoin-web.vercel.app
- **Project:** `cam-douglas-projects/ginzcoin-web`
- **Root Directory:** `apps/web`
- **Preview:** `NEXT_PUBLIC_CHAIN_ID=84532`, address TBD until Phase 4A
- **Production:** `NEXT_PUBLIC_CHAIN_ID=8453`, address after mainnet deploy

Replace `NEXT_PUBLIC_WC_PROJECT_ID` in the Vercel dashboard with a real WalletConnect Cloud ID for wallet connect.

See `.cursor/skills/vercel-deploy-workflow/SKILL.md`.
