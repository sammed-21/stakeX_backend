// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test,console} from "forge-std/Test.sol";
import {Staking} from '../src/Staking.sol';
import {RewardToken} from '../src/RewardToken.sol';
import {StakeXToken} from '../src/StakeXToken.sol';


contract StakingTest is Test {
    StakeXToken stakeXToken;
    RewardToken rewardToken;
    Staking staking;

    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        // Mint 1000 stakeXTokens for Alice and Bob
        stakeXToken = new StakeXToken(1000 * 10**18);
        rewardToken = new RewardToken(1000 * 10**18);

        // Deploy the staking contract
        staking = new Staking(address(stakeXToken), address(rewardToken));

        // Distribute some stakeXTokens to Alice and Bob
        stakeXToken.transfer(alice, 100 * 10**18);
        stakeXToken.transfer(bob, 100 * 10**18);
    }

    function teststakeXTokens() public {
        // Start staking tokens for Alice
        vm.startPrank(alice);

        // Approve and stake 50 tokens from Alice's account
        stakeXToken.approve(address(staking), 50 * 10**18);
        staking.Stake(50 * 10**18);

        // Check that the balance has been staked
        assertEq(staking.stakedBalance(alice), 50 * 10**18);

        vm.stopPrank();
    }

    function testWithdrawTokens() public {
        // Start staking and then withdraw tokens for Alice
        vm.startPrank(alice);

        // Approve and stake 50 tokens from Alice's account
        stakeXToken.approve(address(staking), 50 * 10**18);
        staking.Stake(50 * 10**18);

        // Withdraw 25 tokens
        staking.Withdraw(25 * 10**18);

        // Check that the staked balance has been updated
        assertEq(staking.stakedBalance(alice), 25 * 10**18);

        vm.stopPrank();
    }

    function testClaimRewards() public {
        // Stake tokens and claim rewards for Alice
        vm.startPrank(alice);

        // Approve and stake 50 tokens
        stakeXToken.approve(address(staking), 50 * 10**18);
        staking.Stake(50 * 10**18);

        // Fast forward time to simulate reward accumulation

        skip(1 minutes);

        uint earned = staking.earned(address(alice));
        console.log(earned);
        rewardToken.transfer(address(staking),10000);
        assertGt(rewardToken.balanceOf(address(staking)),earned);



        // Claim the rewards
        staking.getReward(earned);

        // Check that rewards have been claimed (replace `0` with expected reward amount)
        uint reward = staking.rewards(alice);
        assertGt(reward, earned);

        vm.stopPrank();
    }
}
