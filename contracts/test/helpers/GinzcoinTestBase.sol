// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Ginzcoin} from "../../src/Ginzcoin.sol";

abstract contract GinzcoinTestBase is Test {
    address internal owner;
    address internal alice;
    address internal bob;
    address internal pair;

    Ginzcoin internal token;

    function setUpGinzcoin() internal {
        owner = address(this);
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        pair = makeAddr("pair");
        token = new Ginzcoin(owner);
    }

    function _enableTradingWithPair() internal {
        token.setPair(pair);
        token.setExempt(pair, true);
        token.enableTrading();
    }

    function _fund(address user, uint256 amount) internal {
        token.transfer(user, amount);
    }

    function _fundPair(uint256 amount) internal {
        token.transfer(pair, amount);
    }

    function _buyFromPair(address buyer, uint256 amount) internal {
        vm.prank(pair);
        token.transfer(buyer, amount);
    }
}
