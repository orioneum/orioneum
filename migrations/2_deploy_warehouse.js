const Warehouse = artifacts.require("./Warehouse.sol")



module.exports = function(deployer) {
  deployer.deploy(Warehouse)
}
