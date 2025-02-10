# FarmersCoin Smart Contract Documentation

## Overview
FarmersCoin (FC) is an ERC20 token designed to incentivize sustainable farming practices through a reward-based system.

## Token Distribution
- Total Supply: 1,000,000,000 FC
- Testing & Validation: 20%
- Team & Advisors: 10%
- Community Incentives: 15%
- Marketplace Development: 55%

## Core Features

### 1. Staking System
- `stake(uint256 amount)`: Allows users to stake their tokens
- `unstake(uint256 amount)`: Allows users to withdraw staked tokens
- Staking balance and timestamp are tracked for each user

### 2. Premium User System
- `setPremiumStatus(address user, bool status)`: Enables admin to set premium status for users
- Premium status can be checked via `isPremiumUser` mapping

### 3. Sustainable Farming Practices
The contract tracks four key sustainable practices:
- Organic Farming
- Crop Rotation
- Water Conservation
- Soil Management

### 4. Reward System

#### Verification
- `verifyFarmingPractice()`: Admin can verify sustainable farming practices for farmers
- Practices are stored in the `FarmingPractice` struct

#### Reward Generation
- Base reward: 100 tokens
- Weekly limit: 1000 tokens
- 7-day cooldown between rewards
- Rewards are calculated based on verified practices:
  - Organic Farming: 100% of base reward
  - Crop Rotation: 50% of base reward
  - Water Conservation: 50% of base reward
  - Soil Management: 50% of base reward

### 5. Security Features
- Pausable contract functionality
- Owner-controlled administrative functions
- Weekly reward limits
- Cooldown periods

### 6. Events
The contract emits events for:
- Staking/Unstaking
- Reward payments
- Premium status updates
- Practice verification
- Reward generation

## Administrative Functions
- `pause()`: Temporarily halt token transfers
- `unpause()`: Resume token transfers
- `distributeReward()`: Manual reward distribution by admin
- `verifyFarmingPractice()`: Verify sustainable practices

## User Functions
- `stake()`: Stake tokens
- `unstake()`: Withdraw staked tokens
- `generateReward()`: Claim rewards for sustainable practices
- Standard ERC20 transfer functions

## Security Considerations
- All administrative functions are protected by the `onlyOwner` modifier
- Transfer functions are pausable in case of emergencies
- Weekly reward limits prevent exploitation
- Cooldown periods prevent reward farming

## Platform Compatibility & Future Implementations

### 1. Marketplace Integration
The contract includes features specifically designed for our upcoming agricultural marketplace:
- Premium user system for verified farmers
- Staking mechanism for marketplace participation
- Reward distribution system for sustainable practices

### 2. Mobile App Integration
Functions have been implemented to support our future mobile application:
- Simplified reward claiming process
- Practice verification system
- Real-time staking status tracking

### 3. Farm Management Platform
The following features are ready for integration with our farm management system:
- Sustainable practice tracking
- Performance-based rewards
- Automated verification processes

### 4. Cross-Platform Features
The smart contract includes several features designed for cross-platform functionality:
- Standardized event emission for real-time updates
- Flexible reward calculation system
- Scalable verification mechanism
- Pausable functions for maintenance windows

### 5. Future Expansions
The contract architecture allows for future additions through:
- Upgradeable proxy pattern compatibility
- Modular reward calculation system
- Extensible farming practice verification
- Flexible administrative controls

These implementations ensure that FarmersCoin will seamlessly integrate with all planned platform components while maintaining security and scalability.
