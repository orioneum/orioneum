const Utils = artifacts.require("./Utils.sol")



module.exports = function(deployer) {
  deployer.deploy(Utils)
}
