## Part2

In this part:

* MyB2EToken.sol is the token contract of Part1. (*no changes*)
* ICO_B2E.sol is a crowdfunding contract which can sell the token.

### Usage






### Tests (Funding goal not reached)

I deployed this ICO contract using Account1, at the address [0x706c8D3Cfd2896cA01e22Af7A915E69332294bF7](https://ropsten.etherscan.io/address/0x706c8D3Cfd2896cA01e22Af7A915E69332294bF7).

#### Contract creation
The contract creation transaction hash is [0x6ccf9b16801604262863dcc82db33c1302ad4211716febf5a7a61fcb6d9b2417](https://ropsten.etherscan.io/tx/0x6ccf9b16801604262863dcc82db33c1302ad4211716febf5a7a61fcb6d9b2417).

The constructors parameters are the following:

```
ICO_B2E(address _token_adress, uint _start, uint _end, uint _minimumEth, uint _price)
ICO_B2E(0x8Fe77DD9E424dBcB21d20b74150147eeC8AA764E, 1512524800, 1512525700, 5000000000000000, 1000)
```

#### Allowing the ICO to spend the owner's tokens

In this transaction, I approved the ICO contract address to transfer from Account1 the total supply of the tokens: [0x54b4b5f26ff32736b615534c4138561376152f1e4f8c81eec828bcff745dc152](https://ropsten.etherscan.io/tx/0x54b4b5f26ff32736b615534c4138561376152f1e4f8c81eec828bcff745dc152).

#### Invest from Account2 before the start of the ICO

I tried sending 0.0001 ETH before the ICO started, resulting in a Fail: [0x508516fac92c0885fb8fd93257771a79567d31b7acc440277fa52899f912417d](https://ropsten.etherscan.io/tx/0x508516fac92c0885fb8fd93257771a79567d31b7acc440277fa52899f912417d).

#### Invest from Account2 when the ICO is opened (less than the ICO's funding goal)

The same thing but after the ICO started: [0xb070c2bcb6b3a21be8bb4a44ea0057511ca14db6c8b8a32951abd2f82980b4af](https://ropsten.etherscan.io/tx/0xb070c2bcb6b3a21be8bb4a44ea0057511ca14db6c8b8a32951abd2f82980b4af).

The ICO contract recieved 0.0001 ETH, and transfered 0.1 tokens to Account2.

#### Invest from Account2 when the ICO is opened and send the tokens to Account3(less than the ICO's funding goal)

Account2 called DelegateTokensTo(Account3) with a value of 0.00001 ETH: [0x559b1bd868285898249630df9ef391e47206fb7c92ad4c0981a65195958f3352](https://ropsten.etherscan.io/tx/0x559b1bd868285898249630df9ef391e47206fb7c92ad4c0981a65195958f3352).

The ICO contract recieved 0.00001 ETH, and transfered 0.01 tokens to Account3.

#### Invest from Account3 after the end of the ICO

The same thing but after the ICO ended, so the transaction fails: [0xf5b58900529446d178cf8f22df273f9bbd6f389e493e14a9aed364e5ddb7a40d](https://ropsten.etherscan.io/tx/0xf5b58900529446d178cf8f22df273f9bbd6f389e493e14a9aed364e5ddb7a40d).

#### Get a refund after the ICO ended

In this transaction, Account2 called the withdrawIfFailed() function and gets its ether back: [0x78300987a8ed2fd5cc9aa42cb40434da50e58089d99ec68e36c33f9486b692ee](https://ropsten.etherscan.io/tx/0x78300987a8ed2fd5cc9aa42cb40434da50e58089d99ec68e36c33f9486b692ee).


### Tests (Funding goal reached)

I deployed this new ICO contract using Account1, at the address [0x53Eff277a42cB5096C844eCd9DfAF2a733F198f4](https://ropsten.etherscan.io/address/0x53Eff277a42cB5096C844eCd9DfAF2a733F198f4).

#### Contract creation
The contract creation transaction hash is [0x6613f500089f5ff26118672ef0eebb1c99c66220a093152ab9eff82371347cbc](https://ropsten.etherscan.io/tx/0x6613f500089f5ff26118672ef0eebb1c99c66220a093152ab9eff82371347cbc).

The constructors parameters are the following:

```
ICO_B2E(address _token_adress, uint _start, uint _end, uint _minimumEth, uint _price)
ICO_B2E(0x8Fe77DD9E424dBcB21d20b74150147eeC8AA764E, , , 5000000000000000, 1000)
```

#### Roll back the token distribution

First, as I use the same token as the last test, I need to send back the tokens Account2 and Account3 received from the failed ICO, and re-approve the ICO to spend Account1's tokens. The relevant transactions are [0xb776a2d7272fcc8d6de6766132d4e74a80c38464fc9951ce7b78db240972a43d](https://ropsten.etherscan.io/tx/0xb776a2d7272fcc8d6de6766132d4e74a80c38464fc9951ce7b78db240972a43d), [0xdd1bf0e94e015a715741755dab6208b1b14a11b8cd2816c0c3eb61cd9baabbfb](https://ropsten.etherscan.io/tx/0xdd1bf0e94e015a715741755dab6208b1b14a11b8cd2816c0c3eb61cd9baabbfb), and [0x37be2a76992561b30ab79d989b8beac0d559dc4c003a7567ab8bf94832541ed3](https://ropsten.etherscan.io/tx/0x37be2a76992561b30ab79d989b8beac0d559dc4c003a7567ab8bf94832541ed3)

#### Invest from Account2 when the ICO is opened (more than the ICO's funding goal)

I sent 0.01 ETH to the ICO, and received 10 tokens: [0xb2f064e4b0149f384a87a28cc66b3bd2d6090a7121d50b06d85c28a45c11d342](https://ropsten.etherscan.io/tx/0xb2f064e4b0149f384a87a28cc66b3bd2d6090a7121d50b06d85c28a45c11d342).

#### Try to get a refund after the ICO ended

In this transaction, Account2 called the withdrawIfFailed() function. As the funding goal was reached, it doesn't send back the ETH: [0xddd83e8722b1bafcd50907892e78368bece4178a77b17d0543ca4472580abbfd](https://ropsten.etherscan.io/tx/0xddd83e8722b1bafcd50907892e78368bece4178a77b17d0543ca4472580abbfd).

#### Destruct the ICO contract to recover the funds raised

Here, the owner Account1 calls destruct(), and retrieve the 0.01 ETH from the contract: [0x6b82eea4b2e3df9bdc0cf3a4d46be18a88f6759375ab289ab372520ba1149c78](https://ropsten.etherscan.io/tx/0x6b82eea4b2e3df9bdc0cf3a4d46be18a88f6759375ab289ab372520ba1149c78).
