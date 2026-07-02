// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {Ginzcoin} from "../src/Ginzcoin.sol";
import {TeamVesting} from "../src/TeamVesting.sol";
import {GinzConstants} from "../src/GinzConstants.sol";

/// @title Deploy
/// @notice Deploy GINZ + TeamVesting and distribute allocations per tokenomics-config.md
/// @dev Set TEAM_SAFE_ADDRESS, TREASURY_SAFE_ADDRESS, COMMUNITY_WALLET_ADDRESS in env.
///      If unset, defaults to deployer (local/testnet placeholder).
contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        address teamSafe = _envAddressOrDefault("TEAM_SAFE_ADDRESS", deployer);
        address treasurySafe = _envAddressOrDefault("TREASURY_SAFE_ADDRESS", deployer);
        address communityWallet = _envAddressOrDefault("COMMUNITY_WALLET_ADDRESS", deployer);

        vm.startBroadcast(deployerPrivateKey);

        Ginzcoin token = new Ginzcoin(deployer);

        uint64 vestingStart = uint64(block.timestamp + GinzConstants.CLIFF_DURATION);
        TeamVesting vesting = new TeamVesting(teamSafe, vestingStart);

        token.setExempt(address(vesting), true);
        token.setExempt(communityWallet, true);

        require(token.transfer(address(vesting), GinzConstants.TEAM_VESTING_AMOUNT), "vesting transfer failed");
        if (treasurySafe != deployer) {
            require(token.transfer(treasurySafe, GinzConstants.TREASURY_AMOUNT), "treasury transfer failed");
        }
        if (communityWallet != deployer) {
            require(token.transfer(communityWallet, GinzConstants.COMMUNITY_AMOUNT), "community transfer failed");
        }

        vm.stopBroadcast();

        uint256 deployerBalance = token.balanceOf(deployer);
        require(deployerBalance >= GinzConstants.LIQUIDITY_AMOUNT, "deployer LP allocation");

        console2.log("Ginzcoin", address(token));
        console2.log("TeamVesting", address(vesting));
        console2.log("Deployer", deployer);
        console2.log("TeamSafe", teamSafe);
        console2.log("TreasurySafe", treasurySafe);
        console2.log("CommunityWallet", communityWallet);
        console2.log("DeployerBalance (LP allocation)", deployerBalance);

        _writeDeploymentJson(
            block.chainid, address(token), address(vesting), deployer, teamSafe, treasurySafe, communityWallet
        );
    }

    function _envAddressOrDefault(string memory key, address defaultAddr) internal view returns (address) {
        try vm.envAddress(key) returns (address value) {
            if (value == address(0)) return defaultAddr;
            return value;
        } catch {
            return defaultAddr;
        }
    }

    function _writeDeploymentJson(
        uint256 chainId,
        address ginz,
        address teamVesting,
        address deployer,
        address teamSafe,
        address treasurySafe,
        address communityWallet
    ) internal {
        string memory path = string.concat("../deployments/", vm.toString(chainId), ".json");
        string memory json = string.concat(
            "{\n",
            '  "chainId": ',
            vm.toString(chainId),
            ",\n",
            '  "ginz": "',
            vm.toString(ginz),
            '",\n',
            '  "teamVesting": "',
            vm.toString(teamVesting),
            '",\n',
            '  "deployer": "',
            vm.toString(deployer),
            '",\n',
            '  "teamSafe": "',
            vm.toString(teamSafe),
            '",\n',
            '  "treasurySafe": "',
            vm.toString(treasurySafe),
            '",\n',
            '  "communityWallet": "',
            vm.toString(communityWallet),
            '"\n',
            "}\n"
        );
        vm.writeFile(path, json);
        console2.log("Wrote deployment artifact", path);
    }
}
