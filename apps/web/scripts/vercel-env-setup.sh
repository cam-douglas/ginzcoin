#!/usr/bin/env bash
# Document Vercel env matrix for GINZ web (run after `vercel link` from apps/web).
# Requires: vercel CLI authenticated (`vercel login`).

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! command -v vercel >/dev/null 2>&1; then
  echo "Install Vercel CLI: npm i -g vercel"
  exit 1
fi

WC_ID="${NEXT_PUBLIC_WC_PROJECT_ID:?Set NEXT_PUBLIC_WC_PROJECT_ID first}"

echo "Setting Preview (Base Sepolia) env..."
vercel env add NEXT_PUBLIC_CHAIN_ID preview <<< "84532"
vercel env add NEXT_PUBLIC_GINZ_ADDRESS preview <<< "TBD"
vercel env add NEXT_PUBLIC_WC_PROJECT_ID preview <<< "$WC_ID"

echo "Setting Production (Base) env..."
vercel env add NEXT_PUBLIC_CHAIN_ID production <<< "8453"
vercel env add NEXT_PUBLIC_GINZ_ADDRESS production <<< "TBD"
vercel env add NEXT_PUBLIC_WC_PROJECT_ID production <<< "$WC_ID"

echo "Done. Deploy preview: vercel"
echo "Deploy production: vercel --prod"
