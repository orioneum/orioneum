const OrioneumWarehouse = artifacts.require("./OrioneumWarehouse.sol")
const OrioneumFactory = artifacts.require("./OrioneumFactory.sol")
const OrioneumRegistry = artifacts.require("./OrioneumRegistry.sol")

module.exports = function(deployer) {

  deployer.deploy(OrioneumWarehouse)
  deployer.deploy(OrioneumFactory)
}
