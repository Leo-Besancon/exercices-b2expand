## Part4 (Not working)

In this part:

* MyB2EToken.sol is the token contract of Part1 (*no changes*)
* ICO_B2E.sol is the crowdfunding contract of Part2 (*no changes*)
* Proxy_Buyer_Payment_Channel.sol is an impovement of the Proxy_Buyer.sol contract of Part3. It implements payment channels.

### Usage

The Proxy_Buyer_Payment_Channel contract is an intermediary between an user who wants to invest and the ICO contract. It's more complex than the Proxy_Buyer in Part3, as it allows the users to use payment channels

#### Principle behind Payment channels

If an user opens a channel, he will be able to sign messages saying he commits to investing an amount of ether in the ICO.

He can keep commiting to invest more and more ether, as long as the value commited is less than his deposit and the channel is opened.

When the channel is closed, the off-chain transactions are then settled on-chain.

#### Implementation

Here, the recipient of the transactions from the channel is a contract, so it will still be on-chain transactions.

We could imagine that the channels would be directly between an user and the ICO's owner, transactions would then be off-chains and the payment channels would be more useful.

### Tests

First, I deployed a new ICO_B2E contract, using Account1, at the address [0xE1807c8ab79Bfa3682C79a797A88E3E85B5028F8](https://ropsten.etherscan.io/address/0xE1807c8ab79Bfa3682C79a797A88E3E85B5028F8).
Then, I deployed this Proxy_Buyer_Payment_Channel contract using Account1, at the address [0x4CcC4D1d2031824583F9A24a562F2BE3BD23F62C](https://ropsten.etherscan.io/address/0x4CcC4D1d2031824583F9A24a562F2BE3BD23F62C).

#### Contract creation
The ICO_B2E contract creation transaction hash is [0xbc3a8381948346594aadaf616f579aada33a7cb2daf877e0b66025da37630b47](https://ropsten.etherscan.io/tx/0xbc3a8381948346594aadaf616f579aada33a7cb2daf877e0b66025da37630b47).
The Proxy_Buyer_Payment_Channel contract creation transaction hash is [0x40633817574fa5f2f98ea72613950105c4077357199acedd27490bd18b377e60](https://ropsten.etherscan.io/tx/0x40633817574fa5f2f98ea72613950105c4077357199acedd27490bd18b377e60).

The constructors parameters are the following:

```
ICO_B2E(address _token_adress, uint _start, uint _end, uint _minimumEth, uint _price)
ICO_B2E(0x8Fe77DD9E424dBcB21d20b74150147eeC8AA764E, 1512855000, 1512858600, 5000000000000000, 1000)

Proxy_Buyer_Payment_Channel(address _ico_B2E)
Proxy_Buyer_Payment_Channel(0xE1807c8ab79Bfa3682C79a797A88E3E85B5028F8)
```

#### Allowing the ICO to spend the owner's tokens

In this transaction, I approved the ICO contract address to transfer from Account1 the total supply of the tokens: [0xad5d76f0dc9aeba735d752671859df29b724d0e1e46639e6dd454024129ab451](https://ropsten.etherscan.io/tx/0xad5d76f0dc9aeba735d752671859df29b724d0e1e46639e6dd454024129ab451).

#### Openning a channel with Account2

I called the OpenChannel() function with a value of 0.01 ETH: [0xb2da241bb8b4e57b648c8213a0898c58b2bf24e2e5f98e4f4cdbd40d73a69994](https://ropsten.etherscan.io/tx/0xb2da241bb8b4e57b648c8213a0898c58b2bf24e2e5f98e4f4cdbd40d73a69994).

By calling the GetChannelHash() getter with Account2 as argument, we can get the hash of the channel, which we will need to sign messages.
Here, the Hash is: 0x2dab3279e38a1bf31d7ad39e616100687261d2d2af2cbb929f37cfdbfe96a645.

#### Signing messages

In order to use the channel, the user needs to sign a message telling which channel he is using, and the value he wants to commit.

This operation is done off-chain. Here, I connected Account2 to MyEtherWallet and sign the message I need on [this page](https://www.myetherwallet.com/signmsg.html).

Then, I extracted the values of v, r and s based on [this webpage](https://ethereum.stackexchange.com/questions/1777/workflow-on-signing-a-string-with-private-key-followed-by-signature-verificatio). 

In our case, Account2 signed three messages:

* A first message where the value is 0.02 ETH, which exceeds the channel max value:

```
{
  "address": "0x86f3af5490258c386eafd41beeffc998d17f505e",
  "msg": "0x2dab3279e38a1bf31d7ad39e616100687261d2d2af2cbb929f37cfdbfe96a64500000000000000000000000000000000000000000000000000470DE4DF820000",
  "sig": "0x8b6e241bcc24425a9e4fed6194aba1f1647ac95db3714f9e779d1fc5fc6308ac2adef2221dff31e12909fe71078037dacecfd9640382098bee1afc7d3d686a121b",
  "version": "2"
}

r = 0x8b6e241bcc24425a9e4fed6194aba1f1647ac95db3714f9e779d1fc5fc6308ac
s = 0x2adef2221dff31e12909fe71078037dacecfd9640382098bee1afc7d3d686a12
v = 27

```


* A second message where the value is 0.0005 ETH, which should be valid:

```
{
  "address": "0x86f3af5490258c386eafd41beeffc998d17f505e",
  "msg": "0x2dab3279e38a1bf31d7ad39e616100687261d2d2af2cbb929f37cfdbfe96a6450000000000000000000000000000000000000000000000000001C6BF52634000",
  "sig": "0xec46b4251254813fe5c53b8d33db60d442a98dcd7a4baaba07822c56d0d52aea0af335670379466026e8a4dc9ba798401b2ccdf68a41bdf60ba32a848aa0245c1c",
  "version": "2"
}

r = 0xec46b4251254813fe5c53b8d33db60d442a98dcd7a4baaba07822c56d0d52aea
s = 0x0af335670379466026e8a4dc9ba798401b2ccdf68a41bdf60ba32a848aa0245c
v = 28
```

* A third message where the value is 0.001 ETH, which should supersede the second message:


```
{
  "address": "0x86f3af5490258c386eafd41beeffc998d17f505e",
  "msg": "0x2dab3279e38a1bf31d7ad39e616100687261d2d2af2cbb929f37cfdbfe96a64500000000000000000000000000000000000000000000000000038D7EA4C68000",
  "sig": "0xd07c1b4ebded87778424881645968eb3d7ef2e72894516afdca373b5b924300f109fe64acf6c56bfa05acff4a7ca29ddd80ec0a55c605b589ae8b01d8d9425b51c",
  "version": "2"
}

r = 0xd07c1b4ebded87778424881645968eb3d7ef2e72894516afdca373b5b924300f
s = 0x109fe64acf6c56bfa05acff4a7ca29ddd80ec0a55c605b589ae8b01d8d9425b5
v = 28
```					


#### Sending the signed messages and verifying them

Then, we send the three messages to the Proxy_Buyer_Payment_Channel through the SendMessage() function:

* First message (this fails and it is normal): [0x99f81e13301a55751bdbb19b71c700c962fafbd19aba655bb19f40ca2013912b](https://ropsten.etherscan.io/tx/0x99f81e13301a55751bdbb19b71c700c962fafbd19aba655bb19f40ca2013912b).
* Second message: (this fails and it is *not* normal) [0x23fe3d112a51e06015f9f8900c575b5e220257b52429484c1c5216c42050ca0a](https://ropsten.etherscan.io/tx/0x23fe3d112a51e06015f9f8900c575b5e220257b52429484c1c5216c42050ca0a).
* Third message: (this fails and it is *not* normal) [0xc62de4c359fd0c4abe0163f44fc43d44c6afda85db536a23562f167d3881947f](https://ropsten.etherscan.io/tx/0xc62de4c359fd0c4abe0163f44fc43d44c6afda85db536a23562f167d3881947f).

#### Closing the channel and settling the transactions

Then, I called the CloseChannel() function here: (this fails and it is *not* normal) [0xb1494427dae578666d1507a91ae210c9b50e44c0b4f0112e5ef1df92fa30cd25](https://ropsten.etherscan.io/tx/0xb1494427dae578666d1507a91ae210c9b50e44c0b4f0112e5ef1df92fa30cd25).

Two things should have happened:

* The commited value is sent to the ICO with the DelegateTokensTo() function, so we receive the tokens.
* Account2 is refunded the unused value of the channel, which is 0.01 - 0.005 = 0.005 ETH.

