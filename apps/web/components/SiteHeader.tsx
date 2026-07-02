"use client";

import Link from "next/link";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { Badge } from "@/components/ui/badge";

export function SiteHeader() {
  return (
    <header className="border-b border-border/60 bg-background/80 backdrop-blur-sm sticky top-0 z-40">
      <div className="mx-auto flex h-16 max-w-5xl items-center justify-between px-4">
        <Link href="/" className="flex items-center gap-2 font-semibold tracking-tight">
          <span className="text-emerald-400">Ginzcoin</span>
          <Badge variant="secondary" className="font-mono text-xs">
            GINZ
          </Badge>
        </Link>
        <nav className="flex items-center gap-4">
          <Link
            href="/admin"
            className="text-sm text-muted-foreground hover:text-foreground transition-colors"
          >
            Admin
          </Link>
          <ConnectButton showBalance={false} chainStatus="icon" />
        </nav>
      </div>
    </header>
  );
}
