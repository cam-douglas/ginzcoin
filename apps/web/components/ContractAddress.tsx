"use client";

import { useState } from "react";
import { Check, Copy } from "lucide-react";
import { Button } from "@/components/ui/button";
import { getGinzAddress } from "@/lib/contracts/ginzcoin";
import { getContractExplorerUrl } from "@/lib/explorer";

export function ContractAddress() {
  const address = getGinzAddress();
  const [copied, setCopied] = useState(false);

  if (!address) {
    return (
      <p className="text-sm text-muted-foreground">
        Contract address not configured. Set{" "}
        <code className="text-xs">NEXT_PUBLIC_GINZ_ADDRESS</code> after deploy.
      </p>
    );
  }

  async function copyAddress() {
    if (!address) return;
    await navigator.clipboard.writeText(address);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  }

  return (
    <div className="flex flex-col gap-2 sm:flex-row sm:items-center">
      <code className="rounded-md bg-muted px-3 py-2 font-mono text-sm break-all">
        {address}
      </code>
      <div className="flex gap-2">
        <Button type="button" variant="outline" size="sm" onClick={copyAddress}>
          {copied ? (
            <>
              <Check className="size-4" />
              Copied
            </>
          ) : (
            <>
              <Copy className="size-4" />
              Copy
            </>
          )}
        </Button>
        <a
          href={getContractExplorerUrl(address)}
          target="_blank"
          rel="noopener noreferrer"
          className="inline-flex h-8 items-center justify-center rounded-lg px-2.5 text-sm font-medium hover:bg-muted"
        >
          Explorer
        </a>
      </div>
    </div>
  );
}
