// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract DegenGamingClone {

    address public owner;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(uint256 => string) public itemName;
    mapping(uint256 => uint256) public itemPrice;
    mapping(address => uint256) public balance;
    mapping(address => mapping(uint256 => bool)) public redeemedItems;
    mapping(address => uint256) public redeemedItemCount;
    uint256 public itemCount;

    constructor(string memory tokenname, string memory tokensymbol) {
        
        decimals = 10;
        totalSupply = 0;
        owner = msg.sender;
        name = tokenname;
        symbol = tokensymbol;

    }

    modifier onlyOwner() {
        require(msg.sender == owner, "This Operation can only be used by the owner.");
        _;
    }

    event Mint(address indexed to, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Redeem(address indexed user, string itemName);

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
        totalSupply += amount;
        balance[to] += amount;
        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
    }

    function transfer(address receiver, uint256 amount) external returns (bool) {
        require(balance[msg.sender] >= amount, "Payment Failed (Due to Low Balance)");
        balance[msg.sender] -= amount;
        balance[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    function burn(uint256 amount) external {
        require(amount <= balance[msg.sender], "Payment Failed (Due to Low Balance)");
        balance[msg.sender] -= amount;
        totalSupply -= amount;
        emit Burn(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }

    function redeemItem(uint256 itemId) external returns (string memory) {

        require(itemPrice[itemId] > 0, "Wrong item ID.");
        uint256 redemptionAmount = itemPrice[itemId];
        require(balance[msg.sender] >= redemptionAmount, "Payment Failed (Due to Low Balance)");

        balance[msg.sender] -= redemptionAmount;
        redeemedItems[msg.sender][itemId] = true;
        redeemedItemCount[msg.sender]++;
        emit Redeem(msg.sender, itemName[itemId]);

        return itemName[itemId];
    }

    // Basic Functions 

    function getRedeemedItemCount(address user) external view returns (uint256) {
        return redeemedItemCount[user];
    }

    function balanceOf(address accountAddress) external view returns (uint256) {
        return balance[accountAddress];
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
