const Warehouse = artifacts.require("./Warehouse.sol")
const Registry = artifacts.require("./Registry.sol")



module.exports = function(deployer) {
  // Make async to enforce Promise chaining
  deployer.then(async() => {

    // Get handle Warehouse contract and deploy the Registry
    const warehouse = await Warehouse.deployed()
    await deployer.deploy(Registry, warehouse.address)

    // Perform access logic updates
    const registry = await Registry.deployed()
    warehouse.addAllowedSender(registry.address)
  })
}
