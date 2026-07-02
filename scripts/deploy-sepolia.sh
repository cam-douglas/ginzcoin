#!/usr/bin/env bash
# Phase 4A — deploy GINZ to Base Sepolia (chain 84532).
# Prerequisites: .env with PRIVATE_KEY + ETHERSCAN_API_KEY; deployer funded on Sepolia.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f .env ]]; then
  echo "Missing .env — run: cp .env.template .env && fill PRIVATE_KEY and ETHERSCAN_API_KEY"
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

# Foundry vm.envUint requires 0x-prefixed hex
if [[ "$PRIVATE_KEY" != 0x* ]]; then
  export PRIVATE_KEY="0x$PRIVATE_KEY"
fi

RPC="${BASE_SEPOLIA_RPC_URL:-https://sepolia.base.org}"
DEPLOYER="$(cast wallet address --private-key "$PRIVATE_KEY")"
BALANCE="$(cast balance "$DEPLOYER" --rpc-url "$RPC")"

echo "Deployer: $DEPLOYER"
echo "Sepolia balance: $BALANCE wei"

if [[ "$BALANCE" == "0" ]]; then
  echo "ERROR: Deployer has 0 Sepolia ETH. Use the Base Sepolia faucet first."
  exit 1
fi

cd contracts
forge script script/Deploy.s.sol \
  --rpc-url "$RPC" \
  --broadcast \
  --verify \
  -vvv

echo ""
echo "Deployment artifact: $ROOT/deployments/84532.json"
echo "Next: update Vercel preview NEXT_PUBLIC_GINZ_ADDRESS with ginz address from output or JSON."
