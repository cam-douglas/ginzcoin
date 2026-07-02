#!/usr/bin/env bash
# Phase 5 — post-LP owner txs: setExempt, setPair, enableTrading, optional removeLimits
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f .env ]]; then
  echo "Missing .env"
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

export GINZ_ADDRESS="${GINZ_ADDRESS:-0xb0Ae1Ff6f8b822B43D42BB0c210BcaFA70CA3901}"
export PAIR_ADDRESS="${PAIR_ADDRESS:-0x3F9Deaf1143dD9f041308B5385683Ea3bfD560CD}"
export REMOVE_LIMITS="${REMOVE_LIMITS:-true}"

RPC="${BASE_RPC_URL:-https://mainnet.base.org}"
DEPLOYER="$(cast wallet address --private-key "$PRIVATE_KEY")"

echo "Deployer: $DEPLOYER"
echo "GINZ: $GINZ_ADDRESS"
echo "Pool: $PAIR_ADDRESS"
echo "Remove limits: $REMOVE_LIMITS"

cd contracts
forge script script/CompleteLaunch.s.sol \
  --rpc-url "$RPC" \
  --broadcast \
  -vvv

echo ""
echo "Done. Verify on Basescan: tradingActive, pair, limitsEnabled"
