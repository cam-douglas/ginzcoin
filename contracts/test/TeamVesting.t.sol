// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Ginzcoin} from "../src/Ginzcoin.sol";
import {TeamVesting} from "../src/TeamVesting.sol";
import {GinzConstants} from "../src/GinzConstants.sol";

contract TeamVestingTest is Test {
    Ginzcoin internal token;
    TeamVesting internal vesting;
    address internal beneficiary;
    uint64 internal vestingStart;

    function setUp() public {
        beneficiary = makeAddr("teamSafe");
        token = new Ginzcoin(address(this));
        vestingStart = uint64(block.timestamp + GinzConstants.CLIFF_DURATION);
        vesting = new TeamVesting(beneficiary, vestingStart);
        token.setExempt(address(vesting), true);
        token.transfer(address(vesting), GinzConstants.TEAM_VESTING_AMOUNT);
    }

    function test_NoReleaseBeforeCliff() public {
        vm.warp(vestingStart - 1 days);
        assertEq(vesting.releasable(address(token)), 0);

        uint256 before = token.balanceOf(beneficiary);
        vesting.release(address(token));
        assertEq(token.balanceOf(beneficiary), before);
    }

    function test_PartialReleaseAfterCliff() public {
        vm.warp(vestingStart + GinzConstants.VESTING_LINEAR_DURATION / 2);

        uint256 expected = GinzConstants.TEAM_VESTING_AMOUNT / 2;
        assertApproxEqAbs(vesting.releasable(address(token)), expected, 1);

        vesting.release(address(token));
        assertApproxEqAbs(token.balanceOf(beneficiary), expected, 1);
    }

    function test_FullReleaseAfterDuration() public {
        vm.warp(vesting.end());

        vesting.release(address(token));
        assertEq(token.balanceOf(beneficiary), GinzConstants.TEAM_VESTING_AMOUNT);
        assertEq(vesting.releasable(address(token)), 0);
    }
}
