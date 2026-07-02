# GINZ Smart Contracts (Foundry)

Solidity contracts for Ginzcoin (GINZ) on Base. Constants: [`../docs/plans/tokenomics-config.md`](../docs/plans/tokenomics-config.md).

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Copy repo root `.env.example` to `.env` and fill values for deploy

## Build

```bash
cd contracts
forge build
```

## Test

```bash
forge test -vvv
```

13 tests: 10 core matrix + 3 explicit anti-bot sign-off tests in `Ginzcoin.t.sol`, plus 3 `TeamVesting.t.sol` (16 total).

## Format

```bash
forge fmt
forge fmt --check   # CI
```

## Coverage baseline (2026-06-23)

```bash
forge coverage --report summary
```

| File | Lines | Statements | Branches | Funcs |
|------|-------|------------|----------|-------|
| `src/Ginzcoin.sol` | 89.58% | 86.76% | 58.82% | 85.71% |
| Total (incl. script/tests) | 58.82% | 57.26% | 38.46% | 73.33% |

Deploy script coverage is Phase 4 (broadcast integration).

## Deploy (Phase 4)

```bash
# Base Sepolia example
source ../.env
forge script script/Deploy.s.sol:Deploy \
  --rpc-url "$BASE_SEPOLIA_RPC_URL" \
  --broadcast \
  --verify
```

Deployment artifacts are written to `../deployments/<chainId>.json`.

## Contracts

| Contract | Description |
|----------|-------------|
| `Ginzcoin.sol` | 1M fixed-supply ERC-20 with launch limits |
| `TeamVesting.sol` | 150k GINZ, 1y cliff + 3y linear |
| `GinzConstants.sol` | Tokenomics constants |

## CI

GitHub Actions: `.github/workflows/contracts.yml` — `forge fmt --check`, `forge build`, `forge test`.
