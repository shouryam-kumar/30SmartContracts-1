// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract EtherWallet {
    event FundReceived(address payee, uint256 amount, string message);
    error FundTransferUnsuccessful(bool callSuccess);

    address owner;

    constructor() {
        owner = msg.sender;
    }

    // array to store the addresses of the people funding the wallet 
    address[] public fundedBy;

    

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner, get the shit out of here");
        _;
    }

    function checkBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }


    function withdraw() public onlyOwner {
        (bool callSuccess, ) = payable(msg.sender).call{ value: address(this).balance }("");
        if(callSuccess) revert FundTransferUnsuccessful(callSuccess);
    }

    function ownershipTransfer(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    receive() external payable {
        emit FundReceived(msg.sender, msg.value, "Fund recieved");
        fundedBy.push(msg.sender);
    }

    fallback() external payable {
        emit FundReceived(msg.sender, msg.value, "Fund recieved");
        fundedBy.push(msg.sender);
    }

}