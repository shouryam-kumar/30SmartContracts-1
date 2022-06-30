// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract Ownable {
    address public owner;

    event OwnershipTransferred(
        address indexed newOwner,
        address indexed prevOwner
    );

    // the deployer is the initial ownerof the contract 
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner!");
        _;
    }


    // transfer owner to some other address 
    function transferOwnership(address _addr) external onlyOwner {
        require(
            _addr != address(0),
            "Ownership cannot be transferred to null address!"
        );
        owner = _addr;
        emit OwnershipTransferred(owner, msg.sender);
    }

    function checkOwner() public view returns (address) {
        return owner;
    }
}
