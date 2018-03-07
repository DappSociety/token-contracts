var Token = artifacts.require('Token');
var Minter = artifacts.require('Minter');
var Relay = artifacts.require('Relay');
module.exports = function (deployer) {
  deployer.deploy(Token);
  deployer.deploy(Minter);
  deployer.deploy(Relay);
};
