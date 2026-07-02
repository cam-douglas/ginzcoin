# Phase 4A — Base Sepolia deploy

## Agent-ready (already done or runs after your `.env`)

- Contracts built; `forge test` 16/16 pass
- Deploy script supports testnet placeholder (deployer = treasury/community if unset)
- `.env.template` at repo root with public RPC defaults
- `scripts/deploy-sepolia.sh` — one-command Sepolia deploy after `.env` is filled
- Vercel project linked; Preview env has `NEXT_PUBLIC_CHAIN_ID=84532`
- Live site: https://ginzcoin-web.vercel.app

## Completed 2026-06-23

1. `./scripts/deploy-mainnet.sh` — broadcast OK on chain 8453
2. `deployments/8453.json`
3. Verified Ginzcoin + TeamVesting on basescan.org
4. Vercel production `NEXT_PUBLIC_GINZ_ADDRESS=0xb0Ae1Ff6f8b822B43D42BB0c210BcaFA70CA3901`
5. On-chain: 400k deployer / 150k treasury / 300k community / 150k vesting; trading off

## Human-only (remaining)

- Browser connect smoke test on Sepolia preview
- WalletConnect project ID (optional)
