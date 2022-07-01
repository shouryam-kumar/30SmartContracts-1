// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract nft is ERC721 {

    address public immutable owner;
    uint256  public price;
    uint256 public tokenId;
    uint256 public constant totalSupply = 50;

    constructor( string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        owner = msg.sender;
        price = 1 * 1e18; 
    }

    function balance() external view returns(uint256) {
       return balanceOf(msg.sender);
    }

    function mintToken() public payable {
        require(tokenId < totalSupply, "Sorry, the total supply exceeded");
        require(msg.value >= price, "Too low amount");
        _safeMint(msg.sender, tokenId);
        emit Transfer(address(0), msg.sender, tokenId);
        tokenId++;
    }

    function burn(uint256 _tokenId) external {
        _burn(_tokenId);
    }

    function withdraw() external {
        require(msg.sender == owner, "You are not the owner");
        (bool callSuccess,) = payable(owner).call{ value: address(this).balance }("");
        require(callSuccess, "Transaction failed!");
    }

    receive() external payable {
        mintToken();
    }

    fallback() external payable {
        mintToken();
    }
}