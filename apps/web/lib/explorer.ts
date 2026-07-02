import { TARGET_CHAIN_ID } from "@/lib/env";

export function getExplorerBaseUrl(chainId = TARGET_CHAIN_ID): string {
  switch (chainId) {
    case 8453:
      return "https://basescan.org";
    case 84532:
      return "https://sepolia.basescan.org";
    default:
      return "";
  }
}

export function getContractExplorerUrl(
  address: string,
  chainId = TARGET_CHAIN_ID,
): string {
  const base = getExplorerBaseUrl(chainId);
  if (!base) return "#";
  return `${base}/address/${address}`;
}
