"use client";

import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import {
  formatGinz,
  getGinzAddress,
  useGinzcoinReads,
} from "@/lib/contracts/ginzcoin";

function StatRow({
  label,
  value,
  loading,
}: {
  label: string;
  value: React.ReactNode;
  loading?: boolean;
}) {
  return (
    <div className="flex items-center justify-between gap-4 py-2 border-b border-border/40 last:border-0">
      <span className="text-sm text-muted-foreground">{label}</span>
      {loading ? <Skeleton className="h-5 w-24" /> : value}
    </div>
  );
}

export function OnChainStats() {
  const address = getGinzAddress();
  const reads = useGinzcoinReads();

  if (!address) {
    return (
      <Card>
        <CardHeader>
          <CardTitle>On-chain stats</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-muted-foreground">
            Deploy the contract and set{" "}
            <code className="text-xs">NEXT_PUBLIC_GINZ_ADDRESS</code> to load
            live stats.
          </p>
        </CardContent>
      </Card>
    );
  }

  if (reads.isError) {
    return (
      <Card>
        <CardHeader>
          <CardTitle>On-chain stats</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-destructive">
            Failed to read contract. Check RPC URL and contract address.
          </p>
        </CardContent>
      </Card>
    );
  }

  const loading = reads.isLoading;

  return (
    <Card>
      <CardHeader>
        <CardTitle>On-chain stats</CardTitle>
      </CardHeader>
      <CardContent>
        <StatRow
          label="Total supply"
          loading={loading}
          value={
            reads.totalSupply !== undefined ? (
              <span className="font-mono text-sm">{formatGinz(reads.totalSupply)}</span>
            ) : null
          }
        />
        <StatRow
          label="Trading"
          loading={loading}
          value={
            reads.tradingActive !== undefined ? (
              <Badge variant={reads.tradingActive ? "default" : "secondary"}>
                {reads.tradingActive ? "Active" : "Not active"}
              </Badge>
            ) : null
          }
        />
        <StatRow
          label="Limits"
          loading={loading}
          value={
            reads.limitsEnabled !== undefined ? (
              <Badge variant={reads.limitsEnabled ? "outline" : "secondary"}>
                {reads.limitsEnabled ? "Enabled" : "Removed"}
              </Badge>
            ) : null
          }
        />
        {reads.limitsEnabled && reads.maxTransactionAmount !== undefined && (
          <StatRow
            label="Max transaction"
            loading={loading}
            value={
              <span className="font-mono text-sm">
                {formatGinz(reads.maxTransactionAmount)}
              </span>
            }
          />
        )}
        {reads.limitsEnabled && reads.maxWalletAmount !== undefined && (
          <StatRow
            label="Max wallet"
            loading={loading}
            value={
              <span className="font-mono text-sm">
                {formatGinz(reads.maxWalletAmount)}
              </span>
            }
          />
        )}
      </CardContent>
    </Card>
  );
}
