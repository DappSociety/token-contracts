# DappSociety Tokens

>**Everything in this repo is highly experimental**  
It is not secure to use any of this code in production (mainnet) until proper security audits have been conducted. It can result in irreversible loss of funds.

This repo contains DappSociety's implementation for *fairly* minted tokens.

- All new tokens are minted to the contract address
- Users can only receive from this pool when conditions are met

The specifics of the minting and claiming process are customizable. When we decide on final specifications, they will be documented here. Any other project wishing to use these contracts is free to modify their minting and claiming conditions.

## Technical Definition
At the technical level, these are ERC20-compliant tokens that have been extended to provide additional functionality.
