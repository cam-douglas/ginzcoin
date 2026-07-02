import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { TOKENOMICS } from "@/lib/tokenomics";

export function TokenomicsChart() {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Tokenomics</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="flex h-4 w-full overflow-hidden rounded-full">
          {TOKENOMICS.map((bucket) => (
            <div
              key={bucket.label}
              className={`${bucket.color} h-full`}
              style={{ width: `${bucket.percent}%` }}
              title={`${bucket.label}: ${bucket.percent}%`}
            />
          ))}
        </div>
        <ul className="grid gap-3 sm:grid-cols-2">
          {TOKENOMICS.map((bucket) => (
            <li
              key={bucket.label}
              className="flex items-start justify-between gap-2 rounded-lg border border-border/60 p-3"
            >
              <div className="flex items-center gap-2">
                <span className={`size-3 rounded-full ${bucket.color}`} />
                <span className="font-medium">{bucket.label}</span>
              </div>
              <div className="text-right text-sm">
                <div className="font-mono">{bucket.percent}%</div>
                <div className="text-muted-foreground">{bucket.amount} GINZ</div>
              </div>
            </li>
          ))}
        </ul>
      </CardContent>
    </Card>
  );
}
