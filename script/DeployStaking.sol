// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {StakeXToken} from "../src/StakeXToken.sol";
import {RewardToken} from "../src/RewardToken.sol";
import {Staking} from "../src/Staking.sol";

contract DeployStaking is Script {
    function run() external returns (Staking) {
        // Start broadcasting the transaction using the deployer's private key
        vm.startBroadcast();

        // Deploy the StakeXToken with an initial supply of 1000 tokens (scaled by 18 decimals)
        StakeXToken stakeXToken = new StakeXToken(10000 * 10**18);

        // Deploy the RewardToken with an initial supply of 1000 tokens (scaled by 18 decimals)
        RewardToken rewardToken = new RewardToken(100000000 * 10**18);

        // Deploy the Staking contract, passing in the addresses of StakeXToken and RewardToken
        Staking staking = new Staking(address(stakeXToken), address(rewardToken));

        // Stop broadcasting (end the transaction)
        vm.stopBroadcast();
        return staking;
 
    }
}
