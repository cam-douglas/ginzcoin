// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title GinzConstants
/// @notice Tokenomics constants — mirror docs/plans/tokenomics-config.md
library GinzConstants {
    uint256 internal constant TOTAL_SUPPLY = 1_000_000 ether;
    uint256 internal constant LIQUIDITY_AMOUNT = 400_000 ether;
    uint256 internal constant COMMUNITY_AMOUNT = 300_000 ether;
    uint256 internal constant TREASURY_AMOUNT = 150_000 ether;
    uint256 internal constant TEAM_VESTING_AMOUNT = 150_000 ether;
    uint256 internal constant CLIFF_DURATION = 365 days;
    uint256 internal constant VESTING_DURATION = 4 * 365 days;
    uint256 internal constant VESTING_LINEAR_DURATION = VESTING_DURATION - CLIFF_DURATION;
    uint256 internal constant MAX_TX_BPS = 100; // 1%
    uint256 internal constant MAX_WALLET_BPS = 200; // 2%
    uint256 internal constant BPS_DENOMINATOR = 10_000;
}
