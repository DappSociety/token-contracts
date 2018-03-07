pragma solidity ^0.4.19;

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
   * @param _lastMint uint256 A timestamp from the last successful minting
   * @param _inPool uint256 How many tokens are in the contract balance
   * @param _decimals uint8 How many decimals the token uses
   */
  function getMintableAmount(uint256 _lastMint, uint256 _inPool, uint256 _decimals) public view returns (uint256) {
    uint256 cap = 1000000 * 10**_decimals;
    uint256 amount = (now - _lastMint) * 100 * 10**_decimals;
    if (_inPool + amount > cap) { return cap; }
    return amount;
  }
}