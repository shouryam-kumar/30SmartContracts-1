// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.8;

// interface for the standard ERC20
interface IERC721{
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external ;
}

contract EnglishAuction {
    // - Seller can deploy and this auction lasts for a time period
    // - Participants can bid and the highest bidder wins 
    // - Remaining can withdraw and highest one becomes owner  of NFT
    // - Seller can withdraw


    // Events to mark various milestones
    event AuctionStarted();
    event Bid (address indexed sender, uint amount);
    event Withdraw (address indexed bidder, uint256 amount);
    event End (address indexed winner, uint256 amount);

    // initialising nft address and toeknId to be auctioned
    IERC721 public nft;
    uint256 public nftId;


    // assigning the seller payable to withdraw the contract later
    address public seller;
    uint256 public endAt;
    bool public started;
    bool public ended;

    // the address bidding the highest amount 
    address public highestBidder;
    uint256 public highestBid;
    // Mapping to keep track of the bids by the addresses 
    mapping (address => uint) public bids;

    // initialising construtor which takes in all the necessary input to start the auction 
    constructor (address _nft, uint256 _nftId, uint256 _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    // start the auction 
    function start() external {
        require(msg.sender == seller , "NOT A SELLER"); // only seller can start the auction

        nft.safeTransferFrom(msg.sender, address(this), nftId); // transfer the nft to this contract for the period of auction

        started = true;
        endAt = block.timestamp + 7 days; // auction wuill last for 7 days after the start 

        emit AuctionStarted();
    }

    // fucntion to bid 
    function bid() external payable {
        require(started, "BIDDING NOT YET STARTED");
        require(block.timestamp < endAt, "Auction time limit crossed");
        require(msg.value > highestBid, "Not the highest Bid!");

        bids[msg.sender] = msg.value;
        highestBid = msg.value;

        highestBidder = msg.sender;

        emit Bid(msg.sender, msg.value);
    }


    // fucntion for bidders to withdraw bids except the highest bidders
    function withdraw() external {
        require(msg.sender != highestBidder, "HIGHEST BIDDER CANNOT WITHDRAW");
        require(bids[msg.sender] != 0, "You are not a bidder");

        (bool callSuccess,) = payable(msg.sender).call{ value: bids[msg.sender] }("");
        require(callSuccess, "Transaction failed");

        emit Withdraw(msg.sender, bids[msg.sender]);
    }
    
    // function to end teh auction 
    function end() external {
        require(msg.sender == seller, "Not privileged"); // can  be called only by the seller
        require(block.timestamp >= endAt, "Time left"); // cannot be ended before the time period

        ended = true;

        // if there is a highest bidder
        if(highestBidder != address(0)){
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            (bool sent,) = seller.call{ value: address(this).balance }("");
            require(sent, "Transaction failed");
        } else {
            nft.safeTransferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }

}