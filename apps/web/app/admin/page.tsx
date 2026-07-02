"use client";

import { useEffect } from "react";
import Link from "next/link";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";
import { toast } from "sonner";
import { WrongChainBanner, useIsWrongChain } from "@/components/WrongChainBanner";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  formatGinz,
  getGinzAddress,
  useGinzcoinAdmin,
  useGinzcoinReads,
} from "@/lib/contracts/ginzcoin";

function addressesEqual(a?: string, b?: string): boolean {
  return !!a && !!b && a.toLowerCase() === b.toLowerCase();
}

export default function AdminPage() {
  const { address, isConnected } = useAccount();
  const wrongChain = useIsWrongChain();
  const reads = useGinzcoinReads();
  const admin = useGinzcoinAdmin();
  const ginzAddress = getGinzAddress();

  const isOwner = addressesEqual(address, reads.owner);

  useEffect(() => {
    if (admin.isPending) {
      toast.loading("Confirm transaction in wallet…", { id: "admin-tx" });
    }
  }, [admin.isPending]);

  useEffect(() => {
    if (admin.isConfirming) {
      toast.loading("Waiting for confirmation…", { id: "admin-tx" });
    }
  }, [admin.isConfirming]);

  useEffect(() => {
    if (admin.isSuccess) {
      toast.success("Transaction confirmed", { id: "admin-tx" });
      reads.refetch();
      admin.reset();
    }
  }, [admin.isSuccess, admin, reads]);

  useEffect(() => {
    if (admin.writeError) {
      toast.error(admin.writeError.message.slice(0, 120), { id: "admin-tx" });
      admin.reset();
    }
  }, [admin.writeError, admin]);

  return (
    <div className="flex-1">
      <WrongChainBanner />
      <main className="mx-auto max-w-2xl px-4 py-10 space-y-6">
        <div>
          <Link
            href="/"
            className="text-sm text-muted-foreground hover:text-foreground"
          >
            ← Back to home
          </Link>
          <h1 className="mt-2 text-3xl font-bold tracking-tight">Launch admin</h1>
          <p className="mt-1 text-muted-foreground">
            Owner-only controls for enabling trading and removing launch limits.
          </p>
        </div>

        {!ginzAddress && (
          <Card>
            <CardHeader>
              <CardTitle>Contract not configured</CardTitle>
              <CardDescription>
                Set <code>NEXT_PUBLIC_GINZ_ADDRESS</code> in your environment.
              </CardDescription>
            </CardHeader>
          </Card>
        )}

        {ginzAddress && !isConnected && (
          <Card>
            <CardHeader>
              <CardTitle>Connect wallet</CardTitle>
              <CardDescription>
                Connect the contract owner wallet to access admin actions.
              </CardDescription>
            </CardHeader>
            <CardContent>
              <ConnectButton />
            </CardContent>
          </Card>
        )}

        {ginzAddress && isConnected && !isOwner && (
          <Card>
            <CardHeader>
              <CardTitle>Access denied</CardTitle>
              <CardDescription>
                Connected wallet is not the contract owner. Admin actions are
                hidden.
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-2 text-sm">
              <p>
                <span className="text-muted-foreground">Your address: </span>
                <code className="text-xs">{address}</code>
              </p>
              {reads.owner && (
                <p>
                  <span className="text-muted-foreground">Owner: </span>
                  <code className="text-xs">{reads.owner}</code>
                </p>
              )}
            </CardContent>
          </Card>
        )}

        {ginzAddress && isConnected && isOwner && (
          <Card>
            <CardHeader>
              <CardTitle>Contract status</CardTitle>
              <CardDescription>You are connected as the owner.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex flex-wrap gap-2">
                <Badge variant={reads.tradingActive ? "default" : "secondary"}>
                  Trading: {reads.tradingActive ? "Active" : "Not active"}
                </Badge>
                <Badge variant={reads.limitsEnabled ? "outline" : "secondary"}>
                  Limits: {reads.limitsEnabled ? "Enabled" : "Removed"}
                </Badge>
              </div>
              {reads.limitsEnabled && reads.maxTransactionAmount !== undefined && (
                <p className="text-sm text-muted-foreground">
                  Max tx: {formatGinz(reads.maxTransactionAmount)} · Max wallet:{" "}
                  {reads.maxWalletAmount !== undefined
                    ? formatGinz(reads.maxWalletAmount)
                    : "—"}
                </p>
              )}
              <div className="flex flex-col gap-3 sm:flex-row">
                <Button
                  disabled={
                    wrongChain ||
                    reads.tradingActive === true ||
                    admin.isPending ||
                    admin.isConfirming
                  }
                  onClick={() => admin.enableTrading()}
                >
                  Enable trading
                </Button>
                <Button
                  variant="outline"
                  disabled={
                    wrongChain ||
                    reads.limitsEnabled === false ||
                    admin.isPending ||
                    admin.isConfirming
                  }
                  onClick={() => admin.removeLimits()}
                >
                  Remove limits
                </Button>
              </div>
              {wrongChain && (
                <p className="text-sm text-destructive">
                  Switch to the expected network before submitting transactions.
                </p>
              )}
            </CardContent>
          </Card>
        )}
      </main>
    </div>
  );
}
