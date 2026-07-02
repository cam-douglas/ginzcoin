// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {Ginzcoin} from "../src/Ginzcoin.sol";

/// @notice Post-LP owner steps: exempt pool, register pair, enable trading, optional removeLimits
contract CompleteLaunch is Script {
    function run() external {
        address ginz = vm.envAddress("GINZ_ADDRESS");
        address pair = vm.envAddress("PAIR_ADDRESS");
        bool shouldRemoveLimits = vm.envOr("REMOVE_LIMITS", bool(false));

        Ginzcoin token = Ginzcoin(ginz);

        vm.startBroadcast();

        if (!token.isExemptFromLimits(pair)) {
            token.setExempt(pair, true);
        }

        if (token.pair() == address(0)) {
            token.setPair(pair);
        }

        if (!token.tradingActive()) {
            token.enableTrading();
        }

        if (shouldRemoveLimits && token.limitsEnabled()) {
            token.removeLimits();
        }

        vm.stopBroadcast();
    }
}
