// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Staking} from "../src/Staking.sol";
import {StakeXTokenFaucet} from "../src/StakeXTokenFaucet.sol";
import {StakeXToken} from "../src/StakeXToken.sol";

contract StakeXTokenFaucet is Test {
    StakeXTokenFaucet public faucet;
    StakeXToken public stakeXToken;
    address public user1;
    address public user2;
    uint256 constant INITIAL_SUPPLY = 10000 * 10 ** 18;
    uint256 constant FAUCET_AMOUNT = 10 * 10 ** 18;

    function setUp() public {
        stakeXToken = new StakeXToken(INITIAL_SUPPLY);
        faucet = new StakeXTokenFaucet(address(stakeXToken));

        stakeXToken.transfer(address(faucet), INITIAL_SUPPLY);

        user1 = address(0x1234);
        user2 = address(0x5678);
        deal(user1, 10 ether);
        deal(user2, 10 ether);
    }
    function testFaucetInitialization() public {
        assertEq(faucet.faucetAmount(), FAUCET_AMOUNT); // Check initial faucet amount
        assertEq(faucet.cooldownTime(), 12 hours); // Check initial cooldown time
    }

    function testRequestTokens() public {
        skip(13 hours);
        vm.prank(user1); // Set the sender to user1
        faucet.requestTokens();

        assertEq(stakeXToken.balanceOf(user1), FAUCET_AMOUNT); // Verify user1 received the tokens
        assertEq(faucet.lastRequestTime(user1), block.timestamp); // Verify last request time is updated
    }

    function testSetFaucetAmount() public {
        uint256 newFaucetAmount = 20 * 10 ** 18;

        faucet.setFaucetAmount(newFaucetAmount); // Change the faucet amount
        assertEq(faucet.faucetAmount(), newFaucetAmount); // Check that the amount was updated

        // User requests tokens with the new amount
        vm.prank(user1);
        skip(13 hours);
        faucet.requestTokens();
        assertEq(stakeXToken.balanceOf(user1), newFaucetAmount); // Verify user1 received the new amount
    }
}
