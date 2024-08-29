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
