// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {GinzConstants} from "./GinzConstants.sol";

/// @title Ginzcoin (GINZ)
/// @notice Fixed-supply ERC-20 with launch-phase anti-bot limits on Base
contract Ginzcoin is ERC20, ERC20Burnable, Ownable {
    bool public tradingActive;
    bool public limitsEnabled;
    uint256 public maxTransactionAmount;
    uint256 public maxWalletAmount;
    mapping(address => uint256) public lastBuyBlock;
    uint256 public cooldownBlocks;
    mapping(address => bool) public isExemptFromLimits;
    address public pair;

    event TradingEnabled();
    event LimitsRemoved();
    event ExemptUpdated(address indexed account, bool exempt);
    event PairUpdated(address indexed pair);

    error TradingNotActive();
    error ExceedsMaxTransaction();
    error ExceedsMaxWallet();
    error BuyCooldownActive();
    error PairAlreadySet();
    error ZeroAddress();
    error TradingAlreadyActive();

    /// @param initialOwner Receives full 1M supply at deploy; admin for launch functions
    constructor(address initialOwner) ERC20("Ginzcoin", "GINZ") Ownable(initialOwner) {
        if (initialOwner == address(0)) revert ZeroAddress();

        tradingActive = false;
        limitsEnabled = true;
        cooldownBlocks = 0;

        _mint(initialOwner, GinzConstants.TOTAL_SUPPLY);

        maxTransactionAmount = (totalSupply() * GinzConstants.MAX_TX_BPS) / GinzConstants.BPS_DENOMINATOR;
        maxWalletAmount = (totalSupply() * GinzConstants.MAX_WALLET_BPS) / GinzConstants.BPS_DENOMINATOR;

        isExemptFromLimits[initialOwner] = true;
    }

    /// @notice Enable public trading after LP is seeded
    function enableTrading() external onlyOwner {
        tradingActive = true;
        emit TradingEnabled();
    }

    /// @notice Set Uniswap pair address (one-time)
    function setPair(address _pair) external onlyOwner {
        if (_pair == address(0)) revert ZeroAddress();
        if (pair != address(0)) revert PairAlreadySet();
        pair = _pair;
        emit PairUpdated(_pair);
    }

    /// @notice Disable max transaction and max wallet limits
    function removeLimits() external onlyOwner {
        limitsEnabled = false;
        emit LimitsRemoved();
    }

    /// @notice Exempt an address from launch limits (LP, vesting, community wallet)
    function setExempt(address account, bool exempt) external onlyOwner {
        if (account == address(0)) revert ZeroAddress();
        isExemptFromLimits[account] = exempt;
        emit ExemptUpdated(account, exempt);
    }

    /// @notice Tune buy cooldown blocks before trading is enabled
    function setCooldownBlocks(uint256 blocks) external onlyOwner {
        if (tradingActive) revert TradingAlreadyActive();
        cooldownBlocks = blocks;
    }

    function _update(address from, address to, uint256 amount) internal override {
        if (from == address(0) || to == address(0)) {
            super._update(from, to, amount);
            return;
        }

        if (!tradingActive) {
            if (from != owner() && !isExemptFromLimits[from] && !isExemptFromLimits[to]) {
                revert TradingNotActive();
            }
        }

        if (limitsEnabled) {
            bool fromExempt = isExemptFromLimits[from] || from == owner();
            bool toExempt = isExemptFromLimits[to] || to == owner();

            if (!fromExempt && !toExempt) {
                if (amount > maxTransactionAmount) revert ExceedsMaxTransaction();

                if (balanceOf(to) + amount > maxWalletAmount) {
                    revert ExceedsMaxWallet();
                }
            }

            if (pair != address(0) && from == pair && !toExempt) {
                if (cooldownBlocks == 0) {
                    if (lastBuyBlock[to] == block.number) revert BuyCooldownActive();
                } else if (block.number < lastBuyBlock[to] + cooldownBlocks) {
                    revert BuyCooldownActive();
                }
                lastBuyBlock[to] = block.number;
            }
        }

        super._update(from, to, amount);
    }
}
