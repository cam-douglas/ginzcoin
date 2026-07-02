"use client";

import { useAccount, useSwitchChain } from "wagmi";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { TARGET_CHAIN_ID, getTargetChainName } from "@/lib/env";

export function WrongChainBanner() {
  const { isConnected, chainId } = useAccount();
  const { switchChain, isPending } = useSwitchChain();

  if (!isConnected || chainId === TARGET_CHAIN_ID) {
    return null;
  }

  const targetName = getTargetChainName(TARGET_CHAIN_ID);

  return (
    <Alert variant="destructive" className="rounded-none border-x-0 border-t-0">
      <AlertTitle>Wrong network</AlertTitle>
      <AlertDescription className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <span>
          Switch your wallet to <strong>{targetName}</strong> (chain ID{" "}
          {TARGET_CHAIN_ID}) to interact with GINZ.
        </span>
        <Button
          size="sm"
          variant="secondary"
          disabled={isPending}
          onClick={() => switchChain?.({ chainId: TARGET_CHAIN_ID })}
        >
          {isPending ? "Switching…" : `Switch to ${targetName}`}
        </Button>
      </AlertDescription>
    </Alert>
  );
}

export function useIsWrongChain(): boolean {
  const { isConnected, chainId } = useAccount();
  return isConnected && chainId !== TARGET_CHAIN_ID;
}
