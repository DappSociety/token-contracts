/**
 * Swap real contracts in for Mock contracts for use outside `truffle test`
 */
let Token = artifacts.require('PoolMintedTokenMock');
let Minter = artifacts.require('Minter');
module.exports = function (deployer) {
  deployer.deploy(Token);
  deployer.deploy(Minter);
};
