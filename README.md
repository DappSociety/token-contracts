# DappSociety Tokens

>**Everything in this repo is highly experimental**  
It is not secure to use any of this code in production (mainnet) until proper security audits have been conducted. It can result in irreversible loss of funds.

This repo contains DappSociety's implementation for tokens minted to a shared pool.

- All new tokens are minted to the contract address
- Users can only receive from this pool when conditions are met

The specifics of the minting and claiming process are customizable. When we decide on final specifications, they will be documented here. Any other project wishing to use these contracts is free to modify their minting and claiming conditions.

## Technical Definition
At the technical level, these are ERC20-compliant tokens that have been extended to provide additional functionality.

## Testing Instructions
The best/easiest way to test these contracts is using a combination of Truffle, Ganache, and [Ethereum Web Wallet](wallet.ethereum.org).

Before continuing, you should already have Truffle, Ganache, and MetaMask installed.

### Setting Up Private Net with Ganache and MetaMask
1. Launch Ganache
2. Open MetaMask and set Custom RPC to `HTTP://127.0.0.1:7545`

**If you have used Ganache before, you may need to reset**  
1. MetaMask menu > Settings > Reset account
2. Switch off of Custom RPC then back onto it

### Clone and Install
1. Clone this repository and branch
2. Run `npm install` or `yarn`
3. Run `truffle compile && truffle migrate --reset`

### Add Contracts to Ethereum Web Wallet
1. Open Ethereum Web Wallet and login (e.g. to MetaMask)
2. Click "Contracts" up top
3. Click "Watch Contract"
4. Copy and paste contract address from `truffle migrate` console
5. Enter a name (e.g. `Pool Mint Token`)
6. Copy and paste ABI from `/build/contracts/Token.json`

>ABI is the brackets portion here, including the brackets:
> `"abi": [...],` -- Easy to copy if you use a code editor that lets you collapse blocks and then just select the collapsed portion you need.

Repeat steps for `Relay.json`

### Configure Contract Data
Lastly, you need to configure a few settings in the contracts:

1. In Token contract, select function `Set Relay Address` and enter the address for the Relay contract that was output from `truffle migrate`
2. In Relay contract, do the same for `Set Token Address` and `Set Minter Address`.

### All Set
That's it. Now you can play with the functions in the token contracts such as:

- Mint New Tokens (will add tokens to the contract balance)
- Claim From Pool with value `_ids = [0]` (will give you 100 tokens each time)

### Viewing Your Tokens in MetaMask
In MetaMask:

1. Click "Tokens"
2. Click "Add Token"
3. Paste in the Token contract address from `truffle migrate`
4. You should see your balance
5. Run the `Claim From Pool` function again to get 100 more :-)

## Troubleshooting
- Whenever you run `truffle compile && truffle migrate --reset`, you will deploy all new contracts. The old contracts are still there, but the new contracts start with fresh storage. Be mindful of which contract addresses you are using and update them accordingly in the Ethereum Web Wallet if necessary. For example, if you update the Minter contract and redeploy, you will need to update its address within the previously deployed `Relay` contract.
