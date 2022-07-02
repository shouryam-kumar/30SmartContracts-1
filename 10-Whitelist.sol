// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract Whitelist {
// Whitelisting for a token or NFT collection 📃
// - To whitelist or save the add in the contract for the user
// - Should be able to fetch and check 

    address public immutable owner;
    uint8 public maxWhitelistedAddress;

    mapping(address => bool) public whitelisted;
    address[] public whiteListedAddresses;

    constructor(address _owner, uint8 _maxWhitelistedAddress) {
        owner = _owner;
        maxWhitelistedAddress = _maxWhitelistedAddress;
    }

    // modifer for onlyOwner access
    modifier onlyOwner() {
        require(msg.sender == owner, "Error: Ownership privilege not found");
        _;
    }


    // function to add address to the whitelist 
    function addAddress(address _addr) public onlyOwner {
        require(whiteListedAddresses.length < maxWhitelistedAddress, "Maximum limit reached!");
        whitelisted[_addr] = true;
        whiteListedAddresses.push(_addr);
        
    }

    // check if the address is whitelisted
    function checkAddress(address _addr) public view returns(bool) {
        return whitelisted[_addr];
    }
}