pragma solidity ^0.4.18;

import "./MyB2EToken.sol";

contract ICO_B2E {
	
	uint start_timestamp; // Block timestamp to start the ICO
	uint end_timestamp; // Block timestamp to end the ICO
	uint minimumEthGoal; // If not reached by end of ICO, allow everyone to withdraw.
		
	uint public token_sent; // Keep track of the number of tokens sent
	
	uint price; // Price as fraction of token given per wei received
	
	address public owner;
	
	MyB2EToken token;
	
	bool private allowWithdrawals;
	
	 // Store the Eth value received from each adress, to refund if necessary
	struct Receipt {
		uint EthSent;
		bool withdrew;
	}

	mapping(address => Receipt) receipts;
	
	// Functions with this modifier can only be executed by the owner
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
	
	// At creation, the owner must specify the token address, the start and end dates, the crowdfunding goal and the price.
	function ICO_B2E(address _token_adress, uint _start, uint _end, uint _minimumEth, uint _price) public {
        owner = msg.sender;
        start_timestamp = _start;
		end_timestamp = _end;
		minimumEthGoal = _minimumEth;
		price = _price;
		token = MyB2EToken(_token_adress); // The _token_adress is expected to be right!
		token_sent = 0;
		allowWithdrawals = false; 
	}

	// Returns the number of tokens the ICO can give.
	function tokenRemaining() public constant returns (uint _token_remaining) {
		_token_remaining = token.allowance(owner, this);
	}
	
	// The fallback function () is called when someone sends Ether directly to the ICO contract's adress
	// Token owner must have approved the ICO to spend his tokens before the start
	
    function () public payable {
		require(icoStarted());
		require(!icoEnded());
		require(msg.value*price <= tokenRemaining());
		require(receipts[msg.sender].EthSent + msg.value >= receipts[msg.sender].EthSent);

		Receipt memory _receipt = Receipt(msg.value + receipts[msg.sender].EthSent, false);	// memory keyword because it is only temporary. At push it goes to storage.
		receipts[msg.sender] = _receipt;
		token_sent += msg.value*price;
			
		if (!token.transferFrom(owner,msg.sender, msg.value*price)) {
			revert(); }
		}
	
	// Call this function to send Ether to it but send tokens to the _to adress
	function DelegateTokenTo(address _to) public payable {
		require(icoStarted());
		require(!icoEnded());
		require(msg.value*price <= tokenRemaining());
		require(receipts[_to].EthSent + msg.value >= receipts[_to].EthSent);

		Receipt memory _receipt = Receipt(msg.value + receipts[_to].EthSent, false);	// memory keyword because it is only temporary. At push it goes to storage.
		receipts[_to] = _receipt;
		token_sent += msg.value*price;
			
		if (!token.transferFrom(owner,_to, msg.value*price)) {
			revert(); }
		}

	
	function icoEnded() public constant returns (bool ended) {
		ended = (block.timestamp > end_timestamp);
	}
	
	function icoStarted() public constant returns (bool started) {
		started = (block.timestamp > start_timestamp);
	}
	
	function goalReached() public constant returns (bool reached) {
		reached = (token_sent >= minimumEthGoal*price);
	}

	function withdrawIfFailed() public returns (bool success){
		if (!receipts[msg.sender].withdrew
			&& icoEnded()
			&& !goalReached()
			) {
				uint _value = receipts[msg.sender].EthSent;
				receipts[msg.sender].withdrew = true;
				if (!msg.sender.send(_value)) revert();
			return true;
		} else {
			return false;
		}
	}
	
	function destruct() public onlyOwner() {
		selfdestruct(owner);
	}
}
