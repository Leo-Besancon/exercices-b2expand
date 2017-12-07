pragma solidity ^0.4.18;

import "./ICO_B2E.sol";

contract Proxy_Buyer {
	
	address public owner;
	
	ICO_B2E ico;
	
	// Functions with this modifier can only be executed by the owner
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
	
	function Proxy_Buyer(address _ico_B2E) public {
        owner = msg.sender;
		ico = ICO_B2E(_ico_B2E);
	}

	// Used to invest in the ICO.
	
    function Invest() public payable {
		require(msg.value > 0);
		ico.DelegateTokenTo.value(msg.value)(msg.sender);
    }
	
	function destruct() public onlyOwner() {
		selfdestruct(owner);
	}
}