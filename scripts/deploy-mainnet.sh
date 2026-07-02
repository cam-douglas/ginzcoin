#!/usr/bin/env bash
# Phase 4B — deploy GINZ to Base mainnet (chain 8453).
# Prerequisites: .env with PRIVATE_KEY, ETHERSCAN_API_KEY, Safe/wallet addresses; deployer funded on Base.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f .env ]]; then
  echo "Missing .env — run: cp .env.template .env && fill secrets and mainnet addresses"
  exit 1
fi

set -a
# shellcheck disable=SC1091
source .env
set +a

if [[ -z "${PRIVATE_KEY:-}" ]]; then
  echo "PRIVATE_KEY is empty in .env"
  exit 1
fi

if [[ "$PRIVATE_KEY" != 0x* ]]; then
  export PRIVATE_KEY="0x$PRIVATE_KEY"
fi

for var in TEAM_SAFE_ADDRESS TREASURY_SAFE_ADDRESS COMMUNITY_WALLET_ADDRESS; do
  if [[ -z "${!var:-}" ]]; then
    echo "ERROR: $var must be set for mainnet deploy"
    exit 1
  fi
done

RPC="${BASE_RPC_URL:-https://mainnet.base.org}"
DEPLOYER="$(cast wallet address --private-key "$PRIVATE_KEY")"
BALANCE="$(cast balance "$DEPLOYER" --rpc-url "$RPC")"

echo "Deployer: $DEPLOYER"
echo "Team Safe: $TEAM_SAFE_ADDRESS"
echo "Treasury Safe: $TREASURY_SAFE_ADDRESS"
echo "Community: $COMMUNITY_WALLET_ADDRESS"
echo "Base mainnet balance: $BALANCE wei"

if [[ "$BALANCE" == "0" ]]; then
  echo "ERROR: Deployer has 0 ETH on Base mainnet."
  exit 1
fi

cd contracts
forge script script/Deploy.s.sol \
  --rpc-url "$RPC" \
  --broadcast \
  --verify \
  -vvv

echo ""
echo "Deployment artifact: $ROOT/deployments/8453.json"
