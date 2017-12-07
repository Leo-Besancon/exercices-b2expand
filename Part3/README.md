## Part3

In this part:

* MyB2EToken.sol is the token contract of Part1 (*no changes*)
* ICO_B2E.sol is the crowdfunding contract of Part2 (*no changes*)
* Proxy_Buyer.sol is a contract which acts as an intermediary to the ICO contract.

### Usage

The Proxy_Buyer contract is an intermediary between an user who wants to invest and the ICO contract.

In this version of the contract, you send ether to it, and the Proxy_Buyer calls the DelegateTokenTo() function of the ICO, so you receive the tokens.

If the ICO fails to reach its goals, you would have to call yourself the ICO contract to get your refund.

### Tests

First, I deployed a new ICO_B2E contract, using Account1, at the address [0xDccF91D3aA40167348066a232610a5FB0080aa13](https://ropsten.etherscan.io/address/0xDccF91D3aA40167348066a232610a5FB0080aa13).
Then, I deployed this Proxy_Buyer contract using Account1, at the address [0x8EDAc7A6653D3f970Ecb4f91c0326A35b113E420](https://ropsten.etherscan.io/address/0x8EDAc7A6653D3f970Ecb4f91c0326A35b113E420).

#### Contract creation
The ICO_B2E contract creation transaction hash is [0xc08536708177a6420728e95be5c610ccbfb83063b576a6b2cffcebe72e615e65](https://ropsten.etherscan.io/tx/0xc08536708177a6420728e95be5c610ccbfb83063b576a6b2cffcebe72e615e65).
The Proxy_Buyer contract creation transaction hash is [0xf1d495e74291a97c7470c40f0067695994f6071c1adb2c6bc4604e62329e90a3](https://ropsten.etherscan.io/tx/0xf1d495e74291a97c7470c40f0067695994f6071c1adb2c6bc4604e62329e90a3).

The constructors parameters are the following:

```
ICO_B2E(address _token_adress, uint _start, uint _end, uint _minimumEth, uint _price)
ICO_B2E(0x8Fe77DD9E424dBcB21d20b74150147eeC8AA764E, 1512610000, 1512610900, 5000000000000000, 1000)

Proxy_Buyer(address _ico_B2E)
Proxy_Buyer(0xDccF91D3aA40167348066a232610a5FB0080aa13)
```

#### Allowing the ICO to spend the owner's tokens

In this transaction, I approved the ICO contract address to transfer from Account1 the total supply of the tokens: [0x2645051ad2b0556a80c72808b3063ad77e3969b85df99479e1bbd0c4793a8885](https://ropsten.etherscan.io/tx/0x2645051ad2b0556a80c72808b3063ad77e3969b85df99479e1bbd0c4793a8885).

#### Invest from Account2 by using the proxy contract

I sent 0.01 ETH to the Proxy_Buyer's address: [0x896a65e1ba69317617e1bf162f1a419e3c077b10226acbc92fec4bf1fbb65933](https://ropsten.etherscan.io/tx/0x896a65e1ba69317617e1bf162f1a419e3c077b10226acbc92fec4bf1fbb65933).

Account2 then received the 10 tokens. We can follow the call to the ICO_B2E contract in the "Internal Transaction" tab in the transaction overview on Etherscan.
