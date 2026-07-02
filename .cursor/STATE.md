# STATE.md

## Current Objective

- Phase 5 launch complete (LP + trading live). Next: LP lock, DexScreener verify, Operations Safe + ownership transfer (Phase 6).

## Active Items

- LP lock (NFT #5442363) + publish lock tx
- Create Operations Safe → transferOwnership (~7–14 days)
- Optional: DexScreener link on site, community distribution plan

## Files in Active Use

- `deployments/8453.json` — mainnet addresses
- `scripts/deploy-mainnet.sh`
- `apps/web/` — production redeploy

## Open Blockers

- None for launch admin

## Attempts Performed

- Phase 4B mainnet deploy 2026-06-23: success; both contracts verified on basescan.org
- Allocations verified on-chain: 400k deployer / 150k treasury / 300k community / 150k vesting

## Current Working State

- **Uniswap v3 pool (GINZ/USDC 1%):** `0x3F9Deaf1143dD9f041308B5385683Ea3bfD560CD`
- **LP tx:** `0x0955472d57b28adf35b64c44be14bdf44d8e61913a752d1f4340713cb16e6be9` (8 USDC + ~399,991 GINZ)
- **LP NFT token id:** 5442363 (Uniswap v3 Positions NFT)
- **GINZ (Base mainnet):** `0xb0Ae1Ff6f8b822B43D42BB0c210BcaFA70CA3901`
- **TeamVesting:** `0xe3C1cde1274887aBEf013768B9211eEDd2d08f40`
- **Team Safe:** `0xB5913E6Ff792a76681dC4E41dcf2f03081E83F7B`
- **Treasury Safe:** `0x2B706940125831BB31C040FBC89DAFb3efCBb6D3`
- **Community:** `0x5127bd2Fb775Eeb33139bcb1aA65Af06B58f174a`
- **Owner:** deployer `0x45bf9052C198Bc7E786f5897e76FC83016817510`
- `tradingActive=true`, `limitsEnabled=false`, `pair=0x3F9Deaf1143dD9f041308B5385683Ea3bfD560CD`, pool exempt=true
- Production: https://ginzcoin-web.vercel.app

## Next Actions

1. Test small swap on Uniswap; check DexScreener pool page
2. Lock LP NFT #5442363 when ready
3. Operations Safe + transferOwnership (Phase 6)

## Last Updated

- 2026-06-23 — Phase 5 launch admin complete (trading live, limits removed)
