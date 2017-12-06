## Part5

In this part:

* MyB2EToken.sol is the token contract of Part1 (*no changes*)
* ICO_Reentrancy.sol is based on the ICO_B2E contract of Part2. It includes weaknesses in the code to allow the attack.
* Proxy_Buyer_Reentrancy.sol is a contract exploiting the weaknesses of the crowdfunding contract to steal funds through a re-entrancy attack.

### Usage







### Tests

I deployed:

* the  contract using Account1, at the address [](https://ropsten.etherscan.io/address/).
* the Proxy_Buyer_Reentrancy contract using Account2, at the address [](https://ropsten.etherscan.io/address/).

#### Allowing the ICO to spend the owner's tokens

In this transaction, I approved the ICO contract address to transfer from Account1 the total supply of the tokens: [](https://ropsten.etherscan.io/tx/).

#### Invest from Account3 in the ICO

In order to execute the Attack, the ICO_Reentrancy contract needs to have a non-zero ether balance, but the funding goal must not have been reached.
That's why I sent 0.001 eth from Account3 to the ICO: [](https://ropsten.etherscan.io/tx/).

#### Execute the attack

To attack the ICO contract, our contract needs to be able to call the withdrawIfFailed() function. This means we need to invest a little, from the Proxy_Buyer_Reentrancy contract directly.
Account2 calls the Invest() function which does just that here: [](https://ropsten.etherscan.io/tx/).

Then, if the ICO has ended and did not reached its funding goal, you can use the re-entrancy attack by calling Reentrancy(): [](https://ropsten.etherscan.io/tx/).

#### Withdraw the stolen funds

Finally, to complete the attack, Account2 needs to call the destruct() function of the Proxy_Buyer_Reentrancy contract in order to retieve the stolen funds.

This in done in the following transaction: [](https://ropsten.etherscan.io/tx/).









