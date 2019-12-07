const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);

  deployer.deploy(MetaCoin, "0xc1b71486486774B5C4aa9fbeC86CFE6394349992");
};
