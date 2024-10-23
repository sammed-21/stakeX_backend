// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

 import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";

contract StakeXTokenFaucet is Ownable {
    IERC20 public stakeXToken;
    uint256 public faucetAmount=10*10**18;
    uint256 public cooldownTime = 12 hours;

    mapping(address=>uint256) public lastRequestTime;

    event FaucetUsed(address indexed user, uint256 amount);
    event FaucetAmountUpdated(uint256 newAmount);
    event CooldownTimeUpdated(uint256 newCooldownTime);

    constructor(address _stakeXToken){
        stakeXToken = IERC20(_stakeXToken);
    }

    function requestTokens() external {
        require(block.timestamp > cooldownTime + lastRequestTime[msg.sender],"Please wait before requesting again");
        lastRequestTime[msg.sender] = block.timestamp;
        stakeXToken.transfer(msg.sender, faucetAmount);
        emit FaucetUsed(msg.sender, faucetAmount);
    }
      function setFaucetAmount(uint256 _newAmount) external onlyOwner {
        faucetAmount = _newAmount;
        emit FaucetAmountUpdated(_newAmount);
    }

    // Function for the owner to change the cooldown time
    function setCooldownTime(uint256 _newCooldownTime) external onlyOwner {
        cooldownTime = _newCooldownTime;
        emit CooldownTimeUpdated(_newCooldownTime);
    }

    // Function to withdraw tokens from the contract (if needed by the owner)
    function withdrawTokens(uint256 _amount) external onlyOwner {
        stakeXToken.transfer(msg.sender, _amount);
    }
}