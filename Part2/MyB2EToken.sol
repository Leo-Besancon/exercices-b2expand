pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------------------------
// Code based on the following implementation: (c) BokkyPooBah 2017 
// ----------------------------------------------------------------------------------------------

// To follow the ERC20 standard, our token must implement the following interface (https://github.com/ethereum/EIPs/issues/20)
contract ERC20Interface {
	
	// Get the total token supply
    function totalSupply() public constant returns (uint256 total_supply);

    // Get the account balance of another account with address _owner
    function  balanceOf(address _owner) public constant returns (uint256 balance);

    // Send _value amount of tokens to address _to
    function transfer(address _to, uint256 _value) public returns (bool success);

    // Send _value amount of tokens from address _from to address _to
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    // this function is required for some DEX functionality
    function approve(address _spender, uint256 _value) public returns (bool success);

    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);

    // Triggered when tokens are transferred.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // Triggered whenever approve(address _spender, uint256 _value) is called.
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract MyB2EToken is ERC20Interface {

	// Token properties
    string public constant symbol = "B2E";
    string public constant name = "MyB2EToken";
    uint8 public constant decimals = 18;
    uint256 _total_supply = 314159265000000000000000000; 
	
    address public owner;

    // Balances for each account
    mapping(address => uint256) balances;

    // Owner of account approves an address to transfer his token up to a certain amount.
    mapping(address => mapping (address => uint)) allowed;

    function MyB2EToken() public {
        owner = msg.sender;
        balances[owner] = _total_supply; // At creation, we assign all the tokens to the owner
    }
	
    function totalSupply() public constant returns (uint total_supply) {
        total_supply = _total_supply;
    }

    function balanceOf(address _owner) public constant returns (uint balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        if (balances[msg.sender] >= _value 
            && _value > 0
            && balances[_to] + _value > balances[_to] // Protects from overflow
			) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value); // Event must be sent
            return true;
        } else {
            return false;
        }
    }

    // Send _value amount of tokens from address _from to address _to
	// Caller must have been approved by _from to spend their tokens
	
    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        if (balances[_from] >= _value
            && allowed[_from][msg.sender] >= _value
            && _value > 0
            && balances[_to] + _value > balances[_to] // Protects from overflow
			) {
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(_from, _to, _value); // Event must be sent
            return true;
        } else {
            return false;
        }
    }

    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.

    function approve(address _spender, uint _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

	// Lets you check approval status and amount for specific adresses.
    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }
}