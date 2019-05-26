const Utils = artifacts.require("./Utils.sol")
const Warehouse = artifacts.require("./Warehouse.sol")

const Registry = artifacts.require("./Registry.sol")



module.exports = function(deployer) {
  // Make async to enforce Promise chaining
  deployer.then(async() => {

    // Get handle of Utils and Warehouse contract
    let utils = await Utils.deployed()
    let warehouse = await Warehouse.deployed()

    // All required contracts deployed, deploy the updated registry
    await deployer.deploy(Registry, utils.address, warehouse.address)

    // Perform access logic updates
    let registry = await Registry.deployed()
    warehouse.addAllowedSender(registry.address)
  })
}
