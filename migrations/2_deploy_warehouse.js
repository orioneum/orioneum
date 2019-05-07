const OrioneumWarehouse = artifacts.require("./OrioneumWarehouse.sol")

module.exports = function(deployer) {

  deployer.deploy(OrioneumWarehouse)
}
