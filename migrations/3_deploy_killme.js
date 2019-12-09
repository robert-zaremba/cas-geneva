const KillMe = artifacts.require("KillMe");

module.exports = function(deployer) {
  deployer.deploy(KillMe, {overwrite: true});
};
