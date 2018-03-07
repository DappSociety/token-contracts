pragma solidity ^0.4.19;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Minter.sol";
import "./Interfaces/Bounties.sol";

/**
 * @title Relay
 * @dev This contract enables the base value-store contract to be
 * upgradeable as long as that contract has an owner.
 *
 * You may include other contracts directly or use an interface
 * contract and reference deployed versions by address.
 */
contract Relay is Ownable {
  address public tokenAddress;
  address public bountiesAddress;
  address public minterAddress;

  /**
  * @dev Get the amount of tokens that can be minted right now
  * @param _lastMint uint256 The timestamp of the last minting
  * @param _inPool uint256 The amount of tokens in the shared pool
  */
  function getMintableAmount(uint256 _lastMint, uint256 _inPool, uint256 _decimals) public view returns (uint256) {
    Minter minter = Minter(minterAddress);
    return minter.getMintableAmount(_lastMint, _inPool, _decimals);
  }

  /**
  * @dev Get the amount of tokens an address can claim from the pool
  * @param _address address The address to check for
  * @param _ids uint256[] IDs for checking conditions
  * todo: Currently mocked for isolated testing
  */
  function getClaimableAmount(address _address, uint256[] _ids) public view returns (uint256) {
    require(msg.sender == tokenAddress);
    require(_address != 0x0); // suppress warning
    require(_ids[0] == 0); // suppress warning
    return 100; // simple return for testing
  }

  /**
  * @dev Set the address to the current bounties contract
  * @param _address The new contract address
  */
  function setTokenAddress(address _address) public onlyOwner {
    tokenAddress = _address;
  }

  /**
  * @dev Set the address to the current bounties contract
  * @param _address The new contract address
  */
  function setBountiesAddress(address _address) public onlyOwner {
    bountiesAddress = _address;
  }

  /**
  * @dev Set the address to the current bounties contract
  * @param _address The new contract address
  */
  function setMinterAddress(address _address) public onlyOwner {
    minterAddress = _address;
  }
}
