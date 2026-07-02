// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {VestingWallet} from "@openzeppelin/contracts/finance/VestingWallet.sol";
import {GinzConstants} from "./GinzConstants.sol";

/// @title TeamVesting
/// @notice 150k GINZ vesting: 1-year cliff, then 3-year linear release (4 years total)
/// @dev OZ v5.0.2 has no VestingWalletCliff — cliff via delayed start timestamp
contract TeamVesting is VestingWallet {
    /// @param beneficiary Team Safe address
    /// @param startTimestamp Vesting linear schedule start (deploy time + 365 days)
    constructor(address beneficiary, uint64 startTimestamp)
        VestingWallet(beneficiary, startTimestamp, uint64(GinzConstants.VESTING_LINEAR_DURATION))
    {}
}
