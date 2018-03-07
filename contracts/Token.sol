pragma solidity ^0.4.19;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Relay.sol";

/**
 * @title Token
 * @dev ERC20-compatible tokens where all new supply is minted
 * to the contract address. Users can only receive tokens from
 * this pool when certain conditions are met.
 */
contract Token is StandardToken, Ownable {
  string public constant name = "Pool Minted Token"; // rename to your token name
  string public constant symbol = "PMT"; // rename to your token symbol
  uint256 public constant decimals = 0; // set to 0 for testing, 18 is standard
  uint256 public constant initialSupply = 0; // recommend starting at 0
  address public relayAddress = 0x0; // allow for upgrading functionality
  uint256 public timeOfLastMint; // useful for calculating new supply

  /**
   * @dev Constructor that gives initial tokens to the contract address
   */
  function Token() public {
    totalSupply_ += initialSupply;
    balances[this] = initialSupply;
    Transfer(0x0, this, initialSupply);
    timeOfLastMint = now;
  }

  /**
 * @dev Update the relay contract address
 * @param _address address The relay contract deployed address
 */
  function setRelayAddress(address _address) public onlyOwner {
    relayAddress = _address;
  }

  /**
   * @dev Mint new tokens according to and external function
   * Since we will never mint partial tokens, the external
   * function accepts and returns full tokens units.
   * todo: add modifiers and/or require statements
   */
  function mintNewTokens() public {
    Relay relay = Relay(relayAddress);
    uint256 amount = relay.getMintableAmount(timeOfLastMint, balances[this], decimals);
    totalSupply_ += amount;
    balances[this] += amount;
    Transfer(0x0, this, amount);
    timeOfLastMint = now;
  }

  /**
   * @dev Claim an amount of tokens from the contract balance.
   * To make this future proof, accept an array of ids which can be
   * interpreted by target endpoint function.
   * @param _ids uint256[] General purpose array of IDs for determining claimable amount
   * todo: add modifiers and/or require statements
   */
  function claimFromPool(uint256[] _ids) public {
    Relay relay = Relay(relayAddress);
    uint256 amount = relay.getClaimableAmount(msg.sender, _ids);
    balances[msg.sender] += amount;
    balances[this] -= amount;
    Transfer(this, msg.sender, amount);
  }
}
