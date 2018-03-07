pragma solidity ^0.4.19;

/**
 * @title Bounties interface
 * @dev Interface to an external, deployed bounties contract. This can be updated
 * to work with any implementation in the future. Since this interface references
 * a contract outside the repository, it should contain comments.
 */
contract Bounties {
  /**
   * @dev Just an example of an external contract signature
   * @param _address address The address to claim from
   * @param _ids uint256[] An array of bounty IDs
   */
  function claimBounties(address _address, uint256 _ids) public returns (uint256);
}