pragma solidity ^0.4.19;

import "./PoolMintedToken.sol";

/**
 * @title Minter
 * @dev This contract is responsible for calculating how many
 * tokens to mint. It is highly customizable in that whatever
 * value you pass back to `Tokens.sol` (via `Relay.sol`) will
 * be the amount of tokens minted.
 */
contract Minter {
  /**
   * @dev Mint 100 tokens per second with a max *pool* amount of 1 million
   * @param _tokenContract uint256 A timestamp from the last successful minting
   * @return uint256 The amount of new tokens to mint
   */
  function getMintableAmount(address _tokenContract) public view returns (uint256) {
    PoolMintedToken token = PoolMintedToken(_tokenContract);
    uint256 decimals = token.decimals();
    uint256 poolBalance = token.balanceOf(_tokenContract);
    uint256 timeOfLastMint = token.timeOfLastMint();

    uint256 cap = 1000000 * 10**decimals;
    uint256 amount = (now - timeOfLastMint) * 100 * 10**token.decimals();
    if (poolBalance + amount > cap) {
      if (poolBalance > cap) { return 0; }
      return (cap - poolBalance);
    }
    return amount;
  }
}