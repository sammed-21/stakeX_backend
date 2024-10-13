//SPDX-License-Identifier:MIT

pragma solidity ^0.8.27;

import "@openzeppelin/token/ERC20/ERC20.sol";
import "@openzeppelin/utils/ReentrancyGuard.sol";
import "@openzeppelin/utils/math/Math.sol";

contract Staking is ReentrancyGuard {
    using Math for uint256;
    IERC20 public s_stakingXToken;
    IERC20 public s_rewardToken;

    uint public constant REWARD_RATE=1;
    uint private totalStakedTokens;
    uint public rewardPerTokenStored;
    uint public lastUpdateTime;

    mapping(address => uint) public stakedBalance;
    mapping(address => uint) public rewards;
    mapping(address => uint) public userRewardPerTokenPaid;

    event Staked(address indexed user, uint256 indexed amount);
    event Withdrawn(address indexed user, uint256 indexed amount);
    event RewardsClamied(address indexed user, uint256 indexed amount);
    
    modifier updateReward(address account){
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;
        rewards[account] = earned(account);
        userRewardPerTokenPaid[account] = rewardPerTokenStored;
        _;
    }
    constructor(address stakingXToken, address rewardToken) {
        s_stakingXToken = IERC20(stakingXToken);
        s_rewardToken = IERC20(rewardToken);

    }
    
    function rewardPerToken() public view returns(uint){
        if(totalStakedTokens==0){
            return rewardPerTokenStored;
        }
        uint totalTime = block.timestamp - lastUpdateTime;
        uint totalRewards = REWARD_RATE * totalTime;
        return rewardPerTokenStored+totalRewards/totalStakedTokens;

    }
    function earned(address account) public view returns(uint){
        return (stakedBalance[account])*(rewardPerToken()-userRewardPerTokenPaid[account]);
    }

    function Stake(uint amount_) external nonReentrant updateReward(msg.sender) {
        require(amount_>0,"Amount must be greater than zero" );
        totalStakedTokens+=amount_;
        stakedBalance[msg.sender] +=amount_;
        emit Staked(msg.sender, amount_);

        bool success = s_stakingXToken.transferFrom(msg.sender, address(this),amount_);
        require(success, "Transfer failed");
    }

      function Withdraw(uint amount_) external nonReentrant updateReward(msg.sender) {
        require(amount_>0,"Amount must be greater than zero" );
        totalStakedTokens-=amount_;
        stakedBalance[msg.sender]-=amount_;
        emit Withdrawn(msg.sender, amount_);

        bool success = s_stakingXToken.transfer(msg.sender, amount_);
        require(success, "Transfer failed");
    }

        function getReward(uint amount_) external nonReentrant updateReward(msg.sender) {
            uint reward = rewards[msg.sender];
            require(reward>0, "No rewards to claim");
            rewards[msg.sender]=0;

        emit RewardsClamied(msg.sender, amount_);

        bool success = s_rewardToken.transfer(msg.sender, amount_);
        require(success, "Transfer failed");
    }
}