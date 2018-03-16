pragma solidity ^0.4.19;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Minter.sol";

/**
 * @title Pool Minted Token
 * @dev ERC20-compatible tokens where all new supply is minted
 * to the contract address. Users can only receive tokens from
 * this pool when certain conditions are met.
 */
contract PoolMintedToken is StandardToken, Ownable {
  /* Storage */
  string public constant name = "Pool Minted Token"; // rename to your token name
  string public constant symbol = "PMT"; // rename to your token symbol
  uint256 public constant decimals = 0; // set to 0 for testing, 18 is standard
  uint256 public constant initialSupply = 0; // recommend starting at 0
  uint256 public timeOfLastMint; // useful for calculating new supply
  Minter public minter; // allow for upgrading the minting algorithm
  /**
   * These storage variables and their related function may be offloaded
   * to a governance library, contract, or application. Then we would
   * simply link to the governance contract from here.
   */
  mapping (address => bool) public poolManagers; // can transfer from the shared pool
  mapping (address => bool) public poolDelegates; // can transfer from the shared pool
  uint256 public poolDelegatesCount; // total number of pool delegates

  /* Events */
  event PoolManagerUpdated(address who, bool status);
  event PoolDelegateUpdated(address who, bool status);

  /**
   * @dev Constructor that gives initial tokens to the contract address
   */
  function PoolMintedToken() public {
    timeOfLastMint = now;
    totalSupply_ = initialSupply;
    balances[this] = initialSupply;
    Transfer(address(0), this, initialSupply);
  }

  /**
   * @dev Adds or removes permission to transfer tokens from the shared pool.
   *
   * Permission is usually only given to other contracts, but there could be
   * use cases where permission is given to humans.
   *
   * UI should check the event logs to make users aware of which addresses have
   * this permission. Since this is `onlyOwner`, the goal is to freeze it at a
   * certain point, solidifying trust in the distribution process.
   *
   * @param _address The address to update in the mapping
   * @param _status Boolean flag to enable/disable the address
   */
  function setPoolManager(address _address, bool _status) public onlyOwner returns (bool) {
    poolManagers[_address] = _status;
    PoolManagerUpdated(_address, _status);
    return true;
  }

  /**
   * @dev Adds or removes permission to delegate tokens from the shared pool.
   * @param _address The address to update in the mapping
   * @param _status Boolean flag to enable/disable the address
   */
  function setPoolDelegate(address _address, bool _status) public onlyOwner returns (bool) {
    poolDelegates[_address] = _status;
    if (_status) poolDelegatesCount++;
    else poolDelegatesCount--;
    PoolDelegateUpdated(_address, _status);
    return true;
  }

  /**
   * @dev Checks if the address has delegation permission.
   * @param _address The address to check
   */
  function isPoolDelegate(address _address) public view returns (bool) {
    return poolDelegates[_address];
  }

  /**
   * @dev Transfers tokens from the shared pool to another address.
   * @param _to The recipient address
   * @param _value The amount to transfer
   */
  function transferFromPool(address _to, uint256 _value) public returns (bool) {
    require(poolManagers[msg.sender]);
    require(_to != address(0));
    require(_value <= balances[this]);

    balances[this] = balances[this].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(this, _to, _value);
    return true;
  }

  /**
   * @dev Update the minter contract address
   * @param _address address The minter contract deployed address
   */
  function setMinterContract(address _address) public onlyOwner returns (bool) {
    minter = Minter(_address);
    return true;
  }

  /**
   * @dev Mint new tokens according to an external function.
   *  Modifiers and validation should take place over there.
   */
  function mintNewTokens() public returns (bool) {
    uint256 amount = minter.getMintableAmount(this);
    require(amount > 0);
    totalSupply_ = totalSupply_.add(amount);
    balances[this] = balances[this].add(amount);
    Transfer(address(0), this, amount);
    timeOfLastMint = now;
    return true;
  }
}
