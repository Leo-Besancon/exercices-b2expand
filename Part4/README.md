## Part4

In this part:

* MyB2EToken.sol is the token contract of Part1 (*no changes*)
* ICO_B2E.sol is the crowdfunding contract of Part2 (*no changes*)
* Proxy_Buyer_Payment_Channel.sol is an impovement of the Proxy_Buyer.sol contract of Part3. It implements payment channels.

### Usage

The Proxy_Buyer_Payment_Channel contract is an intermediary between an user who wants to invest and the ICO contract. It's more complex than the Proxy_Buyer in Part3, as it allows Payment channels between the users and the ICO.





### Tests

First, I deployed a new ICO_B2E contract, using Account1, at the address [](https://ropsten.etherscan.io/address/).
Then, I deployed this Proxy_Buyer_Payment_Channel contract using Account1, at the address [](https://ropsten.etherscan.io/address/).

#### Allowing the ICO to spend the owner's tokens

In this transaction, I approved the ICO contract address to transfer from Account1 the total supply of the tokens: [](https://ropsten.etherscan.io/tx/).

#### Openning a channel with Account2




#### Using the channel by signing messages




#### Closing the channel





#### Timeout







