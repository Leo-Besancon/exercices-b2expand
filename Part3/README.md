## Part3

In this part:

* MyB2EToken.sol is the token contract of Part1 (*no changes*)
* ICO_B2E.sol is the crowdfunding contract of Part2 (*no changes*)
* Proxy_Buyer.sol is a contract which acts as an intermediary to the ICO contract.

### Usage

The Proxy_Buyer contract is an intermediary between an user who wants to invest and the ICO contract.

In this version of the contract, you send ether to it, and the Proxy_Buyer calls the DelegateTokenTo() function of the ICO, do you receive the tokens.

If the ICO fails to reach its goals, you would have to call yourself the ICO contract to get your refund.

### Tests

First, I deployed a new ICO_B2E contract, using Account1, at the address [](https://ropsten.etherscan.io/address/).
Then, I deployed this Proxy_Buyer contract using Account1, at the address [](https://ropsten.etherscan.io/address/).

#### Allowing the ICO to spend the owner's tokens

In this transaction, I approved the ICO contract address to transfer from Account1 the total supply of the tokens: [](https://ropsten.etherscan.io/tx/).

#### Invest from Account2 by using the proxy contract

I sent 0.01 ETH to the Proxy_Buyer's address: [](https://ropsten.etherscan.io/tx/).
