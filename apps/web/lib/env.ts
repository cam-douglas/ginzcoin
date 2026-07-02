export const TARGET_CHAIN_ID = Number(
  process.env.NEXT_PUBLIC_CHAIN_ID ?? "84532",
);

export const WC_PROJECT_ID =
  process.env.NEXT_PUBLIC_WC_PROJECT_ID?.trim() ?? "";

export const RPC_URL = process.env.NEXT_PUBLIC_RPC_URL?.trim();

export function getTargetChainName(chainId: number): string {
  switch (chainId) {
    case 8453:
      return "Base";
    case 84532:
      return "Base Sepolia";
    case 31337:
      return "Anvil (local)";
    default:
      return `Chain ${chainId}`;
  }
}
