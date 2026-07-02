# Blocker (resolved): Base Sepolia deploy credentials

## Domain

Phase 4A — deploy GINZ + TeamVesting to Base Sepolia

## Resolved

2026-06-23 — user funded deployer; agent deployed and verified

## Outcome

- `deployments/84532.json` written
- GINZ `0xb0Ae1Ff6f8b822B43D42BB0c210BcaFA70CA3901` verified on sepolia.basescan.org
- TeamVesting `0xe3C1cde1274887aBEf013768B9211eEDd2d08f40` verified
- Vercel Preview env updated; preview redeployed

## Notes for future deploys

- CDP faucet at portal.cdp.coinbase.com/products/faucet (not old coinbase.com/faucets URL)
- MetaMask: add **Base Sepolia Testnet** (84532), not Ethereum Sepolia
- Etherscan API key from etherscan.io/myapikey; Foundry needs `etherscan_api_version = "v2"` in foundry.toml
- `PRIVATE_KEY` in `.env` must be hex; deploy script adds `0x` if missing
