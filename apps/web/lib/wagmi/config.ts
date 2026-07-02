import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { base, baseSepolia } from "wagmi/chains";
import { defineChain, http, type Transport } from "viem";
import { RPC_URL, TARGET_CHAIN_ID, WC_PROJECT_ID } from "@/lib/env";

const anvil = defineChain({
  id: 31337,
  name: "Anvil",
  nativeCurrency: { decimals: 18, name: "Ether", symbol: "ETH" },
  rpcUrls: {
    default: { http: [RPC_URL ?? "http://127.0.0.1:8545"] },
  },
});

const chains =
  TARGET_CHAIN_ID === 31337
    ? ([anvil, base, baseSepolia] as const)
    : ([base, baseSepolia] as const);

const transports: Record<number, Transport> = {
  [base.id]: http(),
  [baseSepolia.id]: http(),
};

if (TARGET_CHAIN_ID === 31337) {
  transports[anvil.id] = http(RPC_URL ?? "http://127.0.0.1:8545");
}

export const config = getDefaultConfig({
  appName: "Ginzcoin",
  projectId: WC_PROJECT_ID || "00000000000000000000000000000000",
  chains,
  transports,
  ssr: true,
});

export { anvil };
