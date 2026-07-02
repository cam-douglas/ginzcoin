export const TOKENOMICS = [
  {
    label: "Liquidity",
    percent: 40,
    amount: "400,000",
    color: "bg-emerald-500",
  },
  {
    label: "Community",
    percent: 30,
    amount: "300,000",
    color: "bg-emerald-400",
  },
  {
    label: "Treasury",
    percent: 15,
    amount: "150,000",
    color: "bg-emerald-600",
  },
  {
    label: "Team vesting",
    percent: 15,
    amount: "150,000",
    color: "bg-emerald-300",
  },
] as const;

export const LAUNCH_STATS = {
  fdv: "$20",
  price: "$0.00002",
  totalSupply: "1,000,000 GINZ",
  maxSpend: "~$20 all-in (gas + LP)",
} as const;
