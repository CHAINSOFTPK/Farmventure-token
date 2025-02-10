// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract FarmersCoin is ERC20, Ownable, Pausable {
    // Token distribution constants
    uint256 public constant TOTAL_SUPPLY = 1_000_000_000 * 10**18; // 1 Billion tokens
    uint256 public constant TESTING_VALIDATION = TOTAL_SUPPLY * 20 / 100;  // 20%
    uint256 public constant TEAM_ADVISORS = TOTAL_SUPPLY * 10 / 100;      // 10%
    uint256 public constant COMMUNITY_INCENTIVES = TOTAL_SUPPLY * 15 / 100; // 15%
    uint256 public constant MARKETPLACE_DEVELOPMENT = TOTAL_SUPPLY * 55 / 100; // 55%

    address public constant INITIAL_HOLDER = 0x49Bd093F22F01cE632240B7f4cc86f3da2EA39be;

    // Staking and governance variables
    mapping(address => uint256) public stakingBalance;
    mapping(address => uint256) public stakingTimestamp;
    mapping(address => bool) public isPremiumUser;
    
    // Reward generation constants
    uint256 public constant REWARD_COOLDOWN = 7 days;
    uint256 public constant BASE_REWARD = 100 * 10**18; // 100 tokens
    uint256 public constant MAX_WEEKLY_REWARD = 1000 * 10**18; // 1000 tokens
    
    // Farming practice verification
    struct FarmingPractice {
        bool organicFarming;
        bool cropRotation;
        bool waterConservation;
        bool soilManagement;
        uint256 lastRewardTime;
        uint256 weeklyRewardTotal;
    }
    
    mapping(address => FarmingPractice) public farmerPractices;
    
    // Events
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event PremiumStatusUpdated(address indexed user, bool status);
    event PracticeVerified(address indexed farmer, string practice, bool status);
    event RewardGenerated(address indexed farmer, uint256 amount, string practice);

    constructor() ERC20("Farmers Coin", "FC") Ownable(msg.sender) {
        // Mint initial supply to specified address
        _mint(INITIAL_HOLDER, TOTAL_SUPPLY);
    }

    // Staking functions
    function stake(uint256 amount) external whenNotPaused {
        require(amount > 0, "Cannot stake 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        _transfer(msg.sender, address(this), amount);
        stakingBalance[msg.sender] += amount;
        stakingTimestamp[msg.sender] = block.timestamp;
        
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external {
        require(amount > 0, "Cannot unstake 0");
        require(stakingBalance[msg.sender] >= amount, "Insufficient staked amount");
        
        stakingBalance[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
        
        emit Unstaked(msg.sender, amount);
    }

    // Premium user functions
    function setPremiumStatus(address user, bool status) external onlyOwner {
        isPremiumUser[user] = status;
        emit PremiumStatusUpdated(user, status);
    }

    // Reward distribution for sustainable farming practices
    function distributeReward(address farmer, uint256 amount) public onlyOwner {
        require(amount > 0, "Cannot reward 0 tokens");
        require(balanceOf(address(this)) >= amount, "Insufficient contract balance");
        
        _transfer(address(this), farmer, amount);
        emit RewardPaid(farmer, amount);
    }

    // Verify sustainable farming practices
    function verifyFarmingPractice(
        address farmer,
        bool organic,
        bool rotation,
        bool water,
        bool soil
    ) external onlyOwner {
        FarmingPractice storage practice = farmerPractices[farmer];
        practice.organicFarming = organic;
        practice.cropRotation = rotation;
        practice.waterConservation = water;
        practice.soilManagement = soil;
        
        emit PracticeVerified(farmer, "farming_practices_updated", true);
    }

    // Calculate reward based on verified practices
    function calculateReward(address farmer) public view returns (uint256) {
        FarmingPractice storage practice = farmerPractices[farmer];
        uint256 reward = 0;
        
        if (practice.organicFarming) reward += BASE_REWARD;
        if (practice.cropRotation) reward += BASE_REWARD / 2;
        if (practice.waterConservation) reward += BASE_REWARD / 2;
        if (practice.soilManagement) reward += BASE_REWARD / 2;
        
        return reward;
    }

    // Generate rewards for verified sustainable practices
    function generateReward(address farmer) external {
        require(
            block.timestamp >= farmerPractices[farmer].lastRewardTime + REWARD_COOLDOWN,
            "Reward cooldown active"
        );
        
        uint256 reward = calculateReward(farmer);
        require(reward > 0, "No reward available");
        
        // Check weekly reward limit
        uint256 currentWeek = block.timestamp / 1 weeks;
        uint256 lastWeek = farmerPractices[farmer].lastRewardTime / 1 weeks;
        
        if (currentWeek != lastWeek) {
            farmerPractices[farmer].weeklyRewardTotal = 0;
        }
        
        require(
            farmerPractices[farmer].weeklyRewardTotal + reward <= MAX_WEEKLY_REWARD,
            "Weekly reward limit exceeded"
        );
        
        farmerPractices[farmer].weeklyRewardTotal += reward;
        farmerPractices[farmer].lastRewardTime = block.timestamp;
        
        distributeReward(farmer, reward);
        emit RewardGenerated(farmer, reward, "sustainable_practice_reward");
    }

    // Pause/Unpause functions
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    // Override transfer function to check for paused state
    function transfer(address to, uint256 amount) public virtual override whenNotPaused returns (bool) {
        return super.transfer(to, amount);
    }

    // Override transferFrom function to check for paused state
    function transferFrom(address from, address to, uint256 amount) public virtual override whenNotPaused returns (bool) {
        return super.transferFrom(from, to, amount);
    }
}
