## Part5

In this part:

* MyB2EToken.sol is the token contract of Part1 (*no changes*)
* ICO_Reentrancy.sol is based on the ICO_B2E contract of Part2. It includes weaknesses in the code to allow the attack.
* Proxy_Buyer_Reentrancy.sol is a contract exploiting the weaknesses of the crowdfunding contract to steal funds through a re-entrancy attack.

### Tests

I deployed:

* the ICO_Reentrancy contract using Account1, at the address [0x75a72Ac98FBF32a48f2A0058f4b287395d6c538F](https://ropsten.etherscan.io/address/0x75a72Ac98FBF32a48f2A0058f4b287395d6c538F).
* the Proxy_Buyer_Reentrancy contract using Account2, at the address [0x16A096f50aeC8D8e75bCf33ef7FE4E167C9D7ea5](https://ropsten.etherscan.io/address/0x16A096f50aeC8D8e75bCf33ef7FE4E167C9D7ea5).

#### Contract creation
The ICO_Reentrancy contract creation transaction hash is [0xcf1e109e49b18b111c00f135ba06931df7b563c4f90396016089b870aacaaf2f](https://ropsten.etherscan.io/tx/0xcf1e109e49b18b111c00f135ba06931df7b563c4f90396016089b870aacaaf2f).
The Proxy_Buyer_Reentrancy contract creation transaction hash is [0xab9365854dc37b4e05168b17478c9ec5bbfc11dc451cf7ad7fc3d8cbf28e6866](https://ropsten.etherscan.io/tx/0xab9365854dc37b4e05168b17478c9ec5bbfc11dc451cf7ad7fc3d8cbf28e6866).

The constructors parameters are the following:

```
ICO_Reentrancy(address _token_adress, uint _start, uint _end, uint _minimumEth, uint _price)
ICO_Reentrancy(0x8Fe77DD9E424dBcB21d20b74150147eeC8AA764E, 1512617000, 1512617900, 5000000000000000, 1000)

Proxy_Buyer_Reentrancy(address _ico_Reentrancy)
Proxy_Buyer_Reentrancy(0x75a72Ac98FBF32a48f2A0058f4b287395d6c538F)
```

#### Allowing the ICO to spend the owner's tokens

In this transaction, I approved the ICO contract address to transfer from Account1 the total supply of the tokens: [0x753ba0508be759eeb99a80508aeb478b040fff475fea46230b4929b223038dff](https://ropsten.etherscan.io/tx/0x753ba0508be759eeb99a80508aeb478b040fff475fea46230b4929b223038dff).

#### Invest from Account3 in the ICO

In order to execute the Attack, the ICO_Reentrancy contract needs to have a non-zero ether balance, but the funding goal must not have been reached.
That's why I sent 0.001 ETH from Account3 to the ICO: [0xcabc8d02147e6819312c22ec76d5713ff7dad4ca43cb4d6e844f6c2347e6f665](https://ropsten.etherscan.io/tx/0xcabc8d02147e6819312c22ec76d5713ff7dad4ca43cb4d6e844f6c2347e6f665).

#### Execute the attack from Account2

To attack the ICO contract, our contract needs to be able to call the withdrawIfFailed() function. This means we need to invest a little, from the Proxy_Buyer_Reentrancy contract directly.
Account2 calls the Invest() function with a value of 0.0002 ETH which does just that here: [0x9afff1a985a5d34ff420158f27fa27ca11f0851c04c955cdd2a3f0446ee1ccae](https://ropsten.etherscan.io/tx/0x9afff1a985a5d34ff420158f27fa27ca11f0851c04c955cdd2a3f0446ee1ccae).

The ICO contract now has 0.0012 ETH.

Then, if the ICO has ended and did not reached its funding goal, you can use the re-entrancy attack by calling Reentrancy(): [0x55d8927f8102983b1d77b030f068ab60f55946572a036e22bbd07f94eb52d0b5](https://ropsten.etherscan.io/tx/0x55d8927f8102983b1d77b030f068ab60f55946572a036e22bbd07f94eb52d0b5).
We can see the attack clearly in the "Internal transactions" tab of the Etherscan page.

#### Withdraw the stolen funds

Finally, to complete the attack, Account2 needs to call the destruct() function of the Proxy_Buyer_Reentrancy contract in order to retieve the stolen funds.

This in done in the following transaction: [0x660ef352ccbc8c6cdd543ddfde0519a5bdffd86c0f0e29f3307d9e2b92d49b1b](https://ropsten.etherscan.io/tx/0x660ef352ccbc8c6cdd543ddfde0519a5bdffd86c0f0e29f3307d9e2b92d49b1b).
