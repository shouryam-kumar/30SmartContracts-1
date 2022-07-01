// SPDX-License-Identifier: MIT


pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract ERC200Z is ERC20 {

    constructor (string memory _name, string memory _symbol) ERC20 (_name, _symbol){
        _mint(msg.sender, 100 * 10**18);
    }

    function mint(address _addr, uint256 tokens) external{
        _mint(_addr, tokens);
    }

    
}