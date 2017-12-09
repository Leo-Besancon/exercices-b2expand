pragma solidity ^0.4.18;

import "./ICO_B2E.sol";

contract Proxy_Buyer_Payment_Channel {

	struct Channel {
		bool open;
		uint timestamp_opened;
		uint valueMax;
		uint value;
	}
	
	mapping(bytes32 => Channel) channels;
	mapping(address => bytes32) channel_hashs;
	
	address public owner;
	
	ICO_B2E ico;
	
	// Functions with this modifier can only be executed by the owner
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }

	function Proxy_Buyer_Payment_Channel(address _ico_B2E) public {
        owner = msg.sender;
		ico = ICO_B2E(_ico_B2E);
	}

    function Invest() public payable {
		require(msg.value > 0);
		ico.DelegateTokenTo.value(msg.value)(msg.sender);
    }
	
	// Creates a  payment channel with the user
	
	function OpenChannel() public payable {
		require(msg.value > 0);		// You can't open a channel without funding it.
		require(channel_hashs[msg.sender] == 0); // If there is already an opened channel with this user, throw.
		
		Channel memory channel = Channel(true, block.timestamp, msg.value, 0);
		
		// Hash the channel details using keccak256 (= sha3())
		bytes32 channel_hash = keccak256(msg.sender, ico, block.timestamp); // This hash needs to be unique to avoid replay attacks by copying messages
		
		channel_hashs[msg.sender] = channel_hash;
		channels[channel_hash] = channel;
	}
	
	function SendMessage(bytes32 _h, uint8 _v, bytes32 _r, bytes32 _s, uint _value) public {
		bytes32 channel_hash = channel_hashs[msg.sender];
		Channel memory channel = channels[channel_hash];

		// Check the message is legitimate
		
		require(VerifyMessage(msg.sender, _h, _v, _r, _s, _value) == true);
		require(_value > channel.value);
		
		// If so, update the user's commitments
		
		channel.value = _value;
		
		channels[channel_hash] = channel;
	}
	
	function VerifyMessage(address _user, bytes32 _h, uint8 _v, bytes32 _r, bytes32 _s, uint _value) public constant returns (bool) {
		
		bytes32 channel_hash = channel_hashs[_user];
		Channel memory channel = channels[channel_hash];

		// Check the channel exists, is open and has and ether in
		
		if (channel.open == false) {return false;}
		if (_value <= 0) {return false;}
		if (_value > channel.valueMax) {return false;}
		
		address signer = ecrecover(_h, _v, _r, _s);
		
		// Check the signer of the message is the channel's user
		
		if (signer != _user) {return false;}
				
		bytes32 computed_hash = keccak256(channel_hash, _value);
		
		// Check the value hashed in the message is the one given in argument
		
		if (computed_hash != _h) {return false;}
		
		return true;
	}
	
	function CloseChannel() public {
		
		bytes32 channel_hash = channel_hashs[msg.sender];
		Channel memory channel = channels[channel_hash];
		
		require(channel.open == true);
		
		channel.open = false;

		uint payToICO = channel.value;
		uint refundUser = channel.valueMax - channel.value;
		
		channel_hashs[msg.sender] = bytes32(0);
		
		if(ico.icoEnded() == true) {
			if (!msg.sender.send(channel.valueMax)) {
				revert();
			}
		}
		else {
			ico.DelegateTokenTo.value(payToICO)(msg.sender);
			if (!msg.sender.send(refundUser)) {
				revert();
			}
		}
		
		delete channels[channel_hash];
	}
	
	// Getters for Channel infos
	
	function GetChannelHash(address _user) public constant returns (bytes32 channel_hash) {
		channel_hash = channel_hashs[_user];
	}
	
	function GetChannelOpen(bytes32 _channel_hash) public constant returns (bool open) {
		open = channels[_channel_hash].open;
	}
	
	function GetChannelTimestampOpened(bytes32 _channel_hash) public constant returns (uint timestamp_opened) {
		timestamp_opened = channels[_channel_hash].timestamp_opened;
	}
		
	function GetChannelValueMax(bytes32 _channel_hash) public constant returns (uint valueMax) {
		valueMax = channels[_channel_hash].valueMax;
	}
	
		function GetChannelCurrentValue(bytes32 _channel_hash) public constant returns (uint value) {
		value = channels[_channel_hash].value;
	}
	
	function destruct() public onlyOwner() {
		selfdestruct(owner);
	}
}
