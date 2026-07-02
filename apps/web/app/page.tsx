import { ContractAddress } from "@/components/ContractAddress";
import { OnChainStats } from "@/components/OnChainStats";
import { TokenomicsChart } from "@/components/TokenomicsChart";
import { WrongChainBanner } from "@/components/WrongChainBanner";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { LAUNCH_STATS } from "@/lib/tokenomics";

export default function HomePage() {
  return (
    <div className="flex-1">
      <WrongChainBanner />
      <main className="mx-auto max-w-5xl px-4 py-12 space-y-10">
        <section className="space-y-4 text-center sm:text-left">
          <div className="flex flex-wrap items-center justify-center gap-2 sm:justify-start">
            <h1 className="text-4xl font-bold tracking-tight sm:text-5xl">
              Ginzcoin
            </h1>
            <Badge className="font-mono text-base px-3 py-1">$GINZ</Badge>
          </div>
          <p className="max-w-2xl text-lg text-muted-foreground">
            Fixed-supply ERC-20 on Base. Launch cap: {LAUNCH_STATS.maxSpend}. Target{" "}
            {LAUNCH_STATS.fdv} FDV at {LAUNCH_STATS.price} per token —{" "}
            {LAUNCH_STATS.totalSupply} minted once at deploy.
          </p>
        </section>

        <section className="grid gap-6 lg:grid-cols-2">
          <Card>
            <CardHeader>
              <CardTitle>Contract</CardTitle>
            </CardHeader>
            <CardContent>
              <ContractAddress />
            </CardContent>
          </Card>
          <OnChainStats />
        </section>

        <TokenomicsChart />

        <footer className="border-t border-border/60 pt-8 text-sm text-muted-foreground flex flex-col gap-2 sm:flex-row sm:justify-between">
          <span>Built for Base · Uniswap v3 LP at launch</span>
          <div className="flex gap-4">
            <a href="/admin" className="hover:text-foreground">
              Admin
            </a>
            <a
              href="https://github.com"
              className="hover:text-foreground pointer-events-none opacity-50"
              aria-hidden
            >
              Docs
            </a>
          </div>
        </footer>
      </main>
    </div>
  );
}
