import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import { Toaster } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { SiteHeader } from "@/components/SiteHeader";
import { Web3Provider } from "@/components/providers/Web3Provider";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Ginzcoin (GINZ)",
  description:
    "Ginzcoin — fixed-supply ERC-20 on Base. ~$20 max launch spend; ~$20 FDV target.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className={`dark ${geistSans.variable} ${geistMono.variable} h-full`}>
      <body className="min-h-full flex flex-col antialiased">
        <Web3Provider>
          <TooltipProvider>
            <SiteHeader />
            {children}
            <Toaster richColors position="bottom-right" />
          </TooltipProvider>
        </Web3Provider>
      </body>
    </html>
  );
}
