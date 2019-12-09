const ConvertLib = artifacts.require("ConvertLib");
const LightCoin = artifacts.require("LightCoin");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, LightCoin);

  deployer.deploy(LightCoin, "0xc1b71486486774B5C4aa9fbeC86CFE6394349992");
};
