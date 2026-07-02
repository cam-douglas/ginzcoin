# GINZ Threat Model

**Status:** Phase 0 (2026-06-23)  
**Scope:** Smart contract threats mitigated in Phase 1 code. Operational threats noted for later phases.

Related: [`ginz-token-roadmap.md`](ginz-token-roadmap.md), [`tokenomics-config.md`](tokenomics-config.md)

---

## Threat matrix

| Threat | Impact | Mitigation (Phase 1+) | Phase |
|--------|--------|----------------------|-------|
| **Sniper bots at launch** | Bots buy large supply in block 1 | `tradingActive` default false; max tx 1%; max wallet 2%; same-block buy guard (even when pair exempt from size limits); owner enables trading only after LP | 1 |
| **Transfers before LP seeded** | Public trading before liquidity | `tradingActive == false`; only owner and exempt addresses can transfer | 1 |
| **Uncapped supply / mint rug** | Infinite inflation | Single constructor mint (1M); no public `mint()` | 1 |
| **LP blocked by limits** | Pool cannot swap | Owner calls `setExempt(pair, true)` and `setPair()` before `enableTrading()` | 1, 5 |
| **Insider accumulation** | Whales corner supply at launch | Max wallet 2% while `limitsEnabled` | 1 |
| **Owner key compromise** | Malicious admin txs | Launch via EOA; transfer ownership to Operations Safe post-launch (Phase 6) | 6 |
| **LP removal (rug pull)** | Liquidity withdrawn | Human locks/burns LP NFT after seeding (Phase 5); not contract-enforced | 5 |
| **Pre-LP insider trading** | Team/community dumps before market | Trading disabled until explicit `enableTrading()` | 1, 5 |
| **Vesting bypass** | Team tokens released early | OpenZeppelin `VestingWallet` + `VestingWalletCliff` (365d cliff, 4y schedule) | 1, 2 |
| **Reentrancy on transfer hook** | State corruption | OpenZeppelin ERC20 `_update`; no external calls in hook | 1 |

---

## Trust assumptions

- **Deployer EOA** is trusted through launch to call admin functions honestly.
- **Human LP step** correctly pairs 400k GINZ + ~$8 USDC and locks LP position (≤ ~$20 all-in launch cap).
- **Safe signers** (Team, Treasury, Operations) are trusted 2-of-3 multisig participants.

---

## Out of scope (documented, not mitigated in Phase 1)

- Buy/sell tax (0% by design)
- Pausable transfers
- Timelock on `enableTrading` / `removeLimits`
- On-chain LP lock enforcement
- Legal / securities compliance

---

## Verification

Phase 2 Foundry tests must prove: trading gate, limits, exempt paths, vesting cliff, and no public mint.
