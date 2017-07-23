var P2pinsure = artifacts.require("./p2pinsure.sol");

module.exports = function(deployer) {
  deployer.deploy(P2pinsure, "0x9fa0637fea09f348b1f4f6b7b8650f1fb3a3e34d", false,"MyMutual",10,1);
};
