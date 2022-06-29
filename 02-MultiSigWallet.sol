// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract MultiSigWallet {
    //     Multi SIG wallet
    // - Owned by multiple owners
    // - Can Submit , Approve and confirm Tx by any owner
    // - Check the Transactions and confirmations

    address[] owners; // ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]
    uint256 index;

    constructor(address[] memory _owners) {
        require(_owners.length > 1, "No. of owners cannot be less than two");

        for (uint256 i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "Owner address cannot be zero");
            owners.push(_owners[i]);
        }
    }

    struct Proposal {
        uint256 _index;
        string title;
        address to;
        address proposedBy;
        string purpose;
        uint256 amount;
        uint256 votes;
        address[] alreadyVoted;
        bool executed;
    }

    Proposal[] public proposals;

    modifier onlyOwner() {
        bool owner;
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == msg.sender) {
                _;
                owner = true;
            }
        }
        require(owner, "You are not eligible");
    }

    function proposeTransaction(
        string memory _title,
        address _to,
        string memory _purpose,
        uint256 _amountInEthers
    ) public onlyOwner {
        Proposal memory _proposal = Proposal({
            _index: index,
            title: _title,
            to: _to,
            proposedBy: msg.sender,
            purpose: _purpose,
            amount: _amountInEthers * 1e18,
            votes: 0,
            alreadyVoted: new address[](0),
            executed: false
        });

        proposals.push(_proposal);
        index++;
    }

    function voteOnTransaction(uint256 _index)
        public
        onlyOwner
        returns (string memory, uint256)
    {
        require(_index < proposals.length, "Invalid proposal");

        for (uint256 i = 0; i < proposals[_index].alreadyVoted.length; i++) {
            require(
                proposals[_index].alreadyVoted[i] != msg.sender,
                "Already Voted, get the shit out of here now"
            );
        }

        //increase the vote count of the proposal
        proposals[_index].votes++;
        proposals[_index].alreadyVoted.push(msg.sender);
        return (
            "You have successfully voted in the favour of this proposal index",
            _index
        );
    }

    function executeTransaction(uint256 _index) public onlyOwner {
        require(
            proposals[_index].executed == false &&
                proposals[_index].votes >= (2 * owners.length) / 3,
            "Proposal already executed or less votes"
        );

        (bool callSuccess, ) = payable(proposals[_index].to).call{
            value: proposals[_index].amount
        }("");
        require(callSuccess, "Transaction failed");
        proposals[_index].executed = true;
    }

    function abortProposal(uint256 _index) public onlyOwner {
        require(
            proposals[_index].executed == false &&
                proposals[_index].proposedBy == msg.sender,
            "Conditions not met"
        );
        delete proposals[_index];
    }

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    receive() external payable {}

    fallback() external payable {}
}
