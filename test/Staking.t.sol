// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test,console} from "forge-std/Test.sol";
import {Staking} from '../src/Staking.sol';
import {RewardToken} from '../src/RewardToken.sol';
import {StakeXToken} from '../src/StakeXToken.sol';

contract StakingTest is Test {
    Staking staking ;

    function setUp() public {
        staking = new Staking(address(1),address(2));
    }

      function testGetRewardRate() public {
        assertEq(staking.REWARD_RATE(), 1);
    }

}   