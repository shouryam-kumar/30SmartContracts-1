// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.8;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract NFTCollection is ERC721Enumerable, Ownable {
    string _baseTokenURI;
    uint256 public price = 0.01 ether;
    uint8 public maximumSupply  = 20;
    uint8 public tokenIds;
    bool paused;

    modifier onlyWhenNotPaused() {
        require(paused == false, "Minting paused");
        _;
    }

    constructor(string memory baseURI, string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        _baseTokenURI = baseURI;
    }

    

    function mint() public payable onlyWhenNotPaused {
        require(tokenIds < maximumSupply, "Maximum limit reached");
        require(msg.value >= price, "Not enough fund");
        tokenIds++;
        _safeMint(msg.sender, tokenIds);
    }

    function approveOperator(address _operator, uint8 _tokenId) public {
        _approve(_operator, _tokenId);
    }

    function approveForAll(address _operator, bool _approvedForAll) public {
        setApprovalForAll(_operator, _approvedForAll);
    }

    function checkFullApproval(address _owner, address _operator) public view returns(bool) {
        return isApprovedForAll(_owner, _operator);
    }

    function transferToken (address _from, address _to, uint8 _tokenId) public {
        safeTransferFrom(_from, _to, _tokenId);
    }

    function checkBalance (address _addr) public view returns (uint256)  {
        return balanceOf(_addr);
    }

    function withdraw() public onlyOwner returns (bool) {
        address  _owner = owner();
        (bool sent, ) =  _owner.call{value: address(this).balance}("");
        require (sent, "Transaction Unsuccessful!");
        return sent;
    }

    receive() external payable {
        mint();
    }

    fallback() external payable {
        mint();
    }
}