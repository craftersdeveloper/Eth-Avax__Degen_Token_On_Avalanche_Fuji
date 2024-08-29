# Project: Degen Token (ERC-20): Unlocking the Future of Gaming

Are you up for a challenge that will put your skills to the test? Degen Gaming 🎮, a renowned game studio, has approached you to create a unique token that can reward players and take their game to the next level. You have been tasked with creating a token that can be earned by players in their game and then exchanged for rewards in their in-game store. A smart step towards increasing player loyalty and retention 🧠

To support their ambitious plans, Degen Gaming has selected the Avalanche blockchain, a leading blockchain platform for web3 gaming projects, to create a fast and low-fee token. With these tokens, players can not only purchase items in the store, but also trade them with other players, providing endless possibilities for growth📈
'
Are you ready to join forces with Degen Gaming and help turn their vision into a reality? The gaming world is counting on you to take it to the next level. Will you rise to the challenge 💪, or will it be game over ☠️ for you?

## Introduction 

`DegenGamingClone` is a smart contract developed in Solidity for token management and item redemption. The contract supports a virtual store where items can be redeemed using the contract's token. The owner has administrative privileges for minting tokens, managing the store, and burning tokens.

---
![MetaCrafters Logo](https://assets-global.website-files.com/62418210ede7e7f14869de35/6245c9b2c388101db3d950f5_metacrafterslogo-gold.webp)

---


This project is proudly introduced by MetaCrafters. We appreciate their dedication and innovation in bringing this project to life. Their support and expertise have been invaluable in developing and refining the DegenGamingClone contract.

## Contract Feature 

**Minting new tokens:** The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
**Transferring tokens:** Players should be able to transfer their tokens to others.
**Redeeming tokens:** Players should be able to redeem their tokens for items in the in-game store.
**Checking token balance:** Players should be able to check their token balance at any time.
**Burning tokens:** Anyone should be able to burn tokens, that they own, that are no longer needed.

### Smart Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

// OpenZeppelin Imports
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DegenGamingClone is ERC20 {
    using SafeMath for uint256;

    address public owner;
    mapping(uint256 => string) public itemName;
    mapping(uint256 => uint256) public itemPrice;
    mapping(address => mapping(uint256 => bool)) public redeemedItems;
    mapping(address => uint256) public redeemedItemCount;
    uint256 public itemCount;

    modifier onlyOwner() {
        require(msg.sender == owner, "This Operation can only be used by the owner.");
        _;
    }

    constructor(string memory tokenname, string memory tokensymbol)
        ERC20(tokenname, tokensymbol)
    {
        owner = msg.sender;

    }

    event Redeem(address indexed user, string itemName);


    // Store Operations 
    
    function AutomateUploadItemToStore() external onlyOwner {
        _addItemToStore(0, "Mini Laptop", 5);
        _addItemToStore(1, "Dragon NFT", 10);
        _addItemToStore(2, "Hyper Computer", 20000);
        _addItemToStore(3, "Master Card", 100000);
    }

    function _addItemToStore(uint256 itemId, string memory _itemName, uint256 _itemPrice) internal {
        itemName[itemId] = _itemName;
        itemPrice[itemId] = _itemPrice;
        itemCount++;
    }

    // Main Operations 

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function redeemItem(uint256 itemId) external returns (string memory) {
        require(itemPrice[itemId] > 0, "Wrong item ID.");
        uint256 redemptionAmount = itemPrice[itemId];
        require(balanceOf(msg.sender) >= redemptionAmount, "Payment Failed (Due to Low Balance)");

        _burn(msg.sender, redemptionAmount);
        redeemedItems[msg.sender][itemId] = true;
        redeemedItemCount[msg.sender]++;
        emit Redeem(msg.sender, itemName[itemId]);

        return itemName[itemId];
    }

    // Basic Functions

    function getRedeemedItemCount(address user) external view returns (uint256) {
        return redeemedItemCount[user];
    }

    function getAllItems() external view returns (string[] memory, uint256[] memory) {
        string[] memory names = new string[](itemCount);
        uint256[] memory prices = new uint256[](itemCount);
        
        for (uint256 i = 0; i < itemCount; i++) {
            names[i] = itemName[i];
            prices[i] = itemPrice[i];
        }
        
        return (names, prices);
    }
}
```

## Key Features

- **Token Management**:
  - `mint(address to, uint256 amount)`: Allows the owner to mint tokens to a specified address.
  - `transfer(address receiver, uint256 amount)`: Enables token transfers between users.
  - `burn(uint256 amount)`: Allows users to burn their tokens, reducing the total supply.

- **Virtual Store**:
  - `AutomateUploadItemToStore()`: Allows the owner to prepopulate the store with items.
  - `redeemItem(uint256 itemId)`: Users can redeem tokens for items based on item IDs.

- **Store Management**:
  - `_addItemToStore(uint256 itemId, string memory _itemName, uint256 _itemPrice)`: Internal function to add items to the store.

## Events

- `Mint(address indexed to, uint256 value)`: Emitted when new tokens are minted.
- `Transfer(address indexed from, address indexed to, uint256 value)`: Emitted during token transfers.
- `Burn(address indexed from, uint256 value)`: Emitted when tokens are burned.
- `Redeem(address indexed user, string itemName)`: Emitted when a user redeems an item.

## Usage

1. **Deploy Contract**:
   - Deploy the contract with the desired token name and symbol.

2. **Admin Operations**:
   - Use `AutomateUploadItemToStore()` to populate the store with items.
   - Mint tokens using `mint(address to, uint256 amount)` and manage token supply with `burn(uint256 amount)`.

3. **User Interaction**:
   - Users can check their balance with `balanceOf(address accountAddress)`.
   - Users can redeem items using `redeemItem(uint256 itemId)` and view the items available with `getAllItems()`.

## Security Considerations

- Only the contract owner can perform administrative actions such as minting, burning, and adding items.
- Ensure proper checks and balances to prevent unauthorized access and token manipulation.

For further details, please refer to the Solidity documentation and Ethereum best practices.
