// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {GinzConstants} from "../src/GinzConstants.sol";
import {Ginzcoin} from "../src/Ginzcoin.sol";
import {GinzcoinTestBase} from "./helpers/GinzcoinTestBase.sol";

contract GinzcoinTest is GinzcoinTestBase {
    function setUp() public {
        setUpGinzcoin();
    }

    function test_Deploy_mintsFullSupplyToOwner() public view {
        assertEq(token.totalSupply(), GinzConstants.TOTAL_SUPPLY);
        assertEq(token.balanceOf(owner), GinzConstants.TOTAL_SUPPLY);
        assertFalse(token.tradingActive());
        assertTrue(token.limitsEnabled());
        assertEq(token.maxTransactionAmount(), 10_000 ether);
        assertEq(token.maxWalletAmount(), 20_000 ether);
    }

    function test_Transfer_revertsWhenTradingInactive() public {
        _fund(alice, 1 ether);
        vm.prank(alice);
        vm.expectRevert(Ginzcoin.TradingNotActive.selector);
        token.transfer(bob, 1 ether);
    }

    function test_OwnerCanTransferWhenTradingInactive() public {
        token.transfer(alice, 10 ether);
        assertEq(token.balanceOf(alice), 10 ether);
    }

    function test_EnableTrading_allowsPublicTransfer() public {
        _enableTradingWithPair();
        _fund(alice, 10 ether);
        vm.prank(alice);
        token.transfer(bob, 5 ether);
        assertEq(token.balanceOf(bob), 5 ether);
    }

    function test_MaxTransaction_revertsOverLimit() public {
        _enableTradingWithPair();
        uint256 overLimit = token.maxTransactionAmount() + 1 ether;
        _fund(alice, overLimit);
        vm.prank(alice);
        vm.expectRevert(Ginzcoin.ExceedsMaxTransaction.selector);
        token.transfer(bob, overLimit);
    }

    function test_MaxWallet_revertsOverCap() public {
        _enableTradingWithPair();
        uint256 maxWallet = token.maxWalletAmount();
        _fundPair(maxWallet);
        _buyFromPair(bob, maxWallet - 1 ether);

        _fund(alice, 2 ether);
        vm.prank(alice);
        vm.expectRevert(Ginzcoin.ExceedsMaxWallet.selector);
        token.transfer(bob, 2 ether);
    }

    function test_RemoveLimits_disablesCaps() public {
        _enableTradingWithPair();
        token.removeLimits();

        uint256 largeAmount = 15_000 ether;
        _fund(alice, largeAmount);
        vm.prank(alice);
        token.transfer(bob, largeAmount);
        assertEq(token.balanceOf(bob), largeAmount);
    }

    function test_ExemptPair_notLimited() public {
        token.setPair(pair);
        token.setExempt(pair, true);
        token.enableTrading();

        _fundPair(50_000 ether);
        vm.prank(pair);
        token.transfer(alice, 30_000 ether);
        assertEq(token.balanceOf(alice), 30_000 ether);
    }

    function test_Cooldown_sameBlock() public {
        _enableTradingWithPair();
        _fundPair(20_000 ether);

        _buyFromPair(alice, 5_000 ether);

        vm.prank(pair);
        vm.expectRevert(Ginzcoin.BuyCooldownActive.selector);
        token.transfer(alice, 5_000 ether);

        vm.roll(block.number + 1);
        _buyFromPair(alice, 5_000 ether);
        assertEq(token.balanceOf(alice), 10_000 ether);
    }

    /// @dev Plan sign-off: sells (to == pair) are not cooldown-gated
    function test_SellToPair_sameBlockNoCooldown() public {
        _enableTradingWithPair();
        _fundPair(20_000 ether);
        _buyFromPair(alice, 5_000 ether);

        vm.prank(alice);
        token.transfer(pair, 1_000 ether);
        vm.prank(alice);
        token.transfer(pair, 1_000 ether);

        assertEq(token.balanceOf(alice), 3_000 ether);
    }

    /// @dev Plan sign-off: exempt addresses transfer while trading inactive
    function test_ExemptCanTransferWhenTradingInactive() public {
        address community = makeAddr("community");
        token.setExempt(community, true);
        token.transfer(community, 100 ether);

        vm.prank(community);
        token.transfer(bob, 50 ether);
        assertEq(token.balanceOf(bob), 50 ether);
    }

    /// @dev Plan sign-off: after removeLimits(), max caps and buy cooldown are off
    function test_RemoveLimits_disablesCooldown() public {
        _enableTradingWithPair();
        _fundPair(20_000 ether);
        _buyFromPair(alice, 5_000 ether);
        token.removeLimits();

        vm.prank(pair);
        token.transfer(alice, 5_000 ether);
        assertEq(token.balanceOf(alice), 10_000 ether);
    }

    function testFuzz_transferWithinLimits(uint256 amount) public {
        amount = bound(amount, 1, token.maxTransactionAmount());
        vm.assume(amount <= token.maxWalletAmount());

        _enableTradingWithPair();
        _fund(alice, token.maxWalletAmount());

        vm.prank(alice);
        token.transfer(bob, amount);
        assertEq(token.balanceOf(bob), amount);
    }
}
