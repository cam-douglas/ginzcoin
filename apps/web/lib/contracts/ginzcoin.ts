"use client";

import { useCallback, useMemo } from "react";
import {
  useReadContracts,
  useWriteContract,
  useWaitForTransactionReceipt,
} from "wagmi";
import { formatUnits, getAddress, isAddress } from "viem";
import ginzAbi from "@/lib/abi/Ginzcoin.json";

export const GINZ_ABI = ginzAbi;

export function getGinzAddress(): `0x${string}` | undefined {
  const raw = process.env.NEXT_PUBLIC_GINZ_ADDRESS?.trim();
  if (!raw || raw === "TBD") return undefined;
  if (!isAddress(raw)) return undefined;
  return getAddress(raw);
}

export function formatGinz(amount: bigint): string {
  const formatted = formatUnits(amount, 18);
  const num = Number(formatted);
  if (num >= 1_000_000) {
    return `${(num / 1_000_000).toLocaleString(undefined, { maximumFractionDigits: 2 })}M GINZ`;
  }
  return `${num.toLocaleString(undefined, { maximumFractionDigits: 4 })} GINZ`;
}

export function useGinzcoinReads() {
  const address = getGinzAddress();

  const { data, isLoading, isError, refetch } = useReadContracts({
    contracts: address
      ? [
          { address, abi: GINZ_ABI, functionName: "totalSupply" },
          { address, abi: GINZ_ABI, functionName: "tradingActive" },
          { address, abi: GINZ_ABI, functionName: "limitsEnabled" },
          { address, abi: GINZ_ABI, functionName: "maxTransactionAmount" },
          { address, abi: GINZ_ABI, functionName: "maxWalletAmount" },
          { address, abi: GINZ_ABI, functionName: "owner" },
          { address, abi: GINZ_ABI, functionName: "pair" },
        ]
      : [],
    query: { enabled: !!address },
  });

  return useMemo(() => {
    const configured = !!address;
    if (!configured || !data) {
      return {
        configured,
        isLoading: configured && isLoading,
        isError: configured && isError,
        refetch,
        totalSupply: undefined as bigint | undefined,
        tradingActive: undefined as boolean | undefined,
        limitsEnabled: undefined as boolean | undefined,
        maxTransactionAmount: undefined as bigint | undefined,
        maxWalletAmount: undefined as bigint | undefined,
        owner: undefined as `0x${string}` | undefined,
        pair: undefined as `0x${string}` | undefined,
      };
    }

    return {
      configured,
      isLoading,
      isError,
      refetch,
      totalSupply: data[0]?.result as bigint | undefined,
      tradingActive: data[1]?.result as boolean | undefined,
      limitsEnabled: data[2]?.result as boolean | undefined,
      maxTransactionAmount: data[3]?.result as bigint | undefined,
      maxWalletAmount: data[4]?.result as bigint | undefined,
      owner: data[5]?.result as `0x${string}` | undefined,
      pair: data[6]?.result as `0x${string}` | undefined,
    };
  }, [address, data, isError, isLoading, refetch]);
}

export function useGinzcoinAdmin() {
  const address = getGinzAddress();
  const {
    writeContract,
    data: hash,
    isPending,
    error: writeError,
    reset,
  } = useWriteContract();

  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({
    hash,
  });

  const enableTrading = useCallback(() => {
    if (!address) return;
    writeContract({
      address,
      abi: GINZ_ABI,
      functionName: "enableTrading",
    });
  }, [address, writeContract]);

  const removeLimits = useCallback(() => {
    if (!address) return;
    writeContract({
      address,
      abi: GINZ_ABI,
      functionName: "removeLimits",
    });
  }, [address, writeContract]);

  return {
    configured: !!address,
    enableTrading,
    removeLimits,
    hash,
    isPending,
    isConfirming,
    isSuccess,
    writeError,
    reset,
  };
}
