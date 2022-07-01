// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.7;


contract ERC20 {

    // 1. name and symbol of the token.
    // 2. balance of every address.
    // 3. transfer form one account of another.
    // 4. allow an address to spend on behalf of some address on allowance.
    // 5.
    
    address public owner;
    string public name; // to be defined while creating the token; can be modified only by the owner
    string public symbol; // to be defined while creating the token; can be modified only by the owner
    uint256 totalSupply;
    mapping(address => uint256) public balance; // to store the balance of the address holding the tokens
    mapping(address => mapping(address => uint256)) public approval;

    event Transfer(address indexed sender, address indexed receiver, uint256 amount);
    event Approved(address indexed owner, address indexed sender, uint256 amount);


    constructor(string memory _name, string memory _symbol, uint256 _totalSupply) {
        owner = msg.sender;
        totalSupply = _totalSupply;
        name = _name;
        symbol = _symbol;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You don't have ownership prvilege");
        _;
    }

    // function to change the change the name of the token post creation
    function changeName(string memory _name) public onlyOwner {
        name = _name;
    }

    // function to change the symbol of the ERC20 post cretaion
    function changeSymbol (string memory _symbol) public onlyOwner {
        symbol = _symbol;
    }

    // function to check balance
    function checkBalance () public view returns (uint256){
        return balance[msg.sender];
    }

    // function to transfer amount from the account by the owner himslef
    function transfer(address _recepient, uint256 _amount) external {
        require(balance[msg.sender] > _amount, "You don't have enough balance");
        balance[msg.sender] -= _amount;
        balance[_recepient] += _amount;

        emit Transfer(msg.sender, _recepient, _amount);
    }

    // function to approve an address to perform transactions on behalf of the owners
    function approve(address _sender, uint256 _amount) external {
        approval[msg.sender][_sender] = _amount;
    } 


    // function to transfer by an approved address from another address
    function transferFrom(address _owner, address _recepient, uint256 _amount) external {
        require(balance[msg.sender] > _amount && approval[owner][msg.sender] > _amount, "Too low balance");
        balance[_recepient] += _amount;
        balance[_owner] -= _amount;
        approval[_owner][msg.sender] -= _amount;
        emit Transfer(_owner, _recepient, _amount);
    }

    // mint the tokens to various addresses
    function mint(address _addr, uint256 _amount) public onlyOwner {
        balance[_addr] = _amount;
        totalSupply -= _amount;

        emit Transfer(address(0), _addr, _amount);
    }

    // function to burn some tokens from the total no. of active tokens in the supply
    function burn(address _addr, uint256 _amount) public onlyOwner {
        balance[_addr] -= _amount;
        totalSupply -= _amount;

        emit Transfer(_addr, address(0), _amount);
    }
}