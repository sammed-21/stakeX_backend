// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {StakeXTokenFaucet} from "../src/StakeXTokenFaucet.sol";

contract DeployStakeXTokenFaucet is Script {
    function run() external returns (StakeXTokenFaucet) {
        // The address of the already deployed StakeXToken on the testnet (correct checksummed address)
        address stakeXTokenAddress = 0x7Ae44D9950Db7b464b459b7BCF52616b3e91B1D6;

        // Start broadcasting the transaction using the deployer's private key
        vm.startBroadcast();

        // Deploy the StakeXTokenFaucet contract, passing in the address of the deployed StakeXToken
        StakeXTokenFaucet faucet = new StakeXTokenFaucet(stakeXTokenAddress);

        // Stop broadcasting (end the transaction)
        vm.stopBroadcast();
        return faucet;
    }
}
