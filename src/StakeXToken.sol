// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

 import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";

contract StakeXToken is ERC20 {
     constructor(uint256 initialSupply) ERC20("StakeXToken", "STX") {
        _mint(msg.sender, initialSupply);
    }
}