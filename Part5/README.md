## Part5

In this part:

* MyB2EToken.sol is the token contract of Part1 (*no changes*)
* ICO_Reentrancy.sol is based on the ICO_B2E contract of Part2. It includes weaknesses in the code to allow the attack.
* Proxy_Buyer_Reentrancy.sol is a contract exploiting the weaknesses of the crowdfunding contract to steal funds through a re-entrancy attack.

### Usage







### Tests

I deployed:
* the ICO_Reentrancy contract using Account1, at the address [](https://ropsten.etherscan.io/address/).
* the Proxy_Buyer_Reentrancy contract using Account2, at the address [](https://ropsten.etherscan.io/address/).












