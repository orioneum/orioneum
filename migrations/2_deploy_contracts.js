const Warehouse = artifacts.require("./Warehouse.sol")
const Registry = artifacts.require("./Orioneum.sol")

module.exports = function(deployer) {
    deployer.deploy(Warehouse)
    // deployer.deploy(Registry)
}
