// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract PiggyBank {
    // 1. deposit fund
    // 2. when withdrawn, destroy the contract and force send amount to the owner

    // to be emitted whenever someone deposits an amount to the piggy bank
    event Deposit(uint256 _amount, address _depositer);

    // once initialized, this value would become immutable;
    address immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }


    // default functions to receive ethers into the contract
    receive() external payable {
        emit Deposit(msg.value, msg.sender);
    }

    fallback() external payable {
        emit Deposit(msg.value, msg.sender);
    }


    // returns the balance of the contract 
    function balance() public view onlyOwner returns (uint256) {
        return (address(this).balance);
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner);
        _;
    }

    function withdraw(uint256 _amount, address _to) external returns (bool) {
        (bool callSuccess, ) = payable(_to).call{value: (_amount * 1e18)}("");
        require(
            callSuccess,
            "An error occured, transaction couldn't be completed"
        );

        // force sends the balance to the address passed and then destroys the contract;
        selfdestruct(payable(i_owner));

        return (callSuccess);
    }
}
