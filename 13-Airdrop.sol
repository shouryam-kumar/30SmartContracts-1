// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.7;

interface IERC20 {
    function transferFrom (address from, address to, uint256 amount) external returns (bool) ;
}

interface IERC721 {
    function safeTransferFrom (address from, address to, uint256 tokenId) external;
}

interface IERC1155 {
    function safeTransferFrom (address from, address to, uint256 id, uint amount, bytes calldata data) external;
}

contract Airdrop {
    //function to bulkAirDrop ERC20

    function bulkAirDropERC20 (IERC20 _token, address[] calldata _to, uint256[] calldata _value ) external  {
        require(_to.length == _value.length , "Address and values length mismatch");
        for (uint256 i; i< _to.length; i++) {
            require(_token.transferFrom(msg.sender, _to[i], _value[i]));
        }
    }

    function bulkAirDropERC721 (IERC721 _token, address[] calldata _to, uint256[] calldata _id) external {
        require(_to.length == _id.length, "Address and id lengths mismatch");
        for(uint256 i=0 ; i < _to.length; i++) {
            _token.safeTransferFrom(msg.sender, _to[i], _id[i]);
        }
    }

    function bulkAirDropERC1155 (IERC1155 _token, address[] calldata _to, uint256[] calldata _id, uint256[] calldata _amount)  external {
        require(_to.length == _id.length, "Address andid length mismatch");
        for(uint256 i = 0; i < _to.length; i++) {
            _token.safeTransferFrom(msg.sender, _to[i], _id[i], _amount[i], "");
        }
    }
}