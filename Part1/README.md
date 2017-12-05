## Part1

In this part, MyB2EToken.sol is a contract for an ERC20 token.

### Usage

This token is implementing the ERC20 interface, so you can check an address's balance, transfer tokens to an address, and give permission to an address to spend your tokens.

### Tests

I deployed this token using Account1, at the address [0x8Fe77DD9E424dBcB21d20b74150147eeC8AA764E](https://ropsten.etherscan.io/address/0x8Fe77DD9E424dBcB21d20b74150147eeC8AA764E).

#### Contract creation
The contract creation transaction hash is [0x33f301daf496e76dc9a1442163ed7080016327783277ed3803db0c82f5695092](https://ropsten.etherscan.io/tx/0x33f301daf496e76dc9a1442163ed7080016327783277ed3803db0c82f5695092).

Here, BalanceOf(Account1) returns the total supply of my token (314159265000000000000000000).

#### Sending Account1's tokens to Account2

I sent 10 tokens in the transaction [0x427eb713e42947ea3a0dcc68841f741b9de2b84a8c121f908e392b8cbc0ab4bf](https://ropsten.etherscan.io/tx/0x427eb713e42947ea3a0dcc68841f741b9de2b84a8c121f908e392b8cbc0ab4bf).

Here, BalanceOf(Account2) shows the 10 tokens (10000000000000000000 as I use 18 decimals).

#### Allowing Account3 to transfer tokens from Account2

In this transaction, I approved Account3 to transfer from Account2 the 10 tokens: [0x8147eedf2662f62e14bda6e010f830a68252081496abc97d21c125521fe8bdd7](https://ropsten.etherscan.io/tx/0x8147eedf2662f62e14bda6e010f830a68252081496abc97d21c125521fe8bdd7).

#### Send back the tokens to Account1

In this transaction, Account3 used the transferFrom function to transfer the 10 tokens in Account2 to Account1: [0x004768f44aef379ceaf37d73fc7afb6848ff3d30410b4e8bad99b098efa5d275](https://ropsten.etherscan.io/tx/0x004768f44aef379ceaf37d73fc7afb6848ff3d30410b4e8bad99b098efa5d275).

Now, BalanceOf(Account2) shows the 0 tokens, BalanceOf(Account1) shows the total supply.
