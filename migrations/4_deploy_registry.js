const Factory = artifacts.require("./Factory.sol")
const Warehouse = artifacts.require("./Warehouse.sol")

const Registry = artifacts.require("./Registry.sol")



module.exports = function(deployer) {
  // Make async to enforce Promise chaining
  deployer.then(async() => {

    // Get handle of Factory and Warehouse contract
    let factory = await Factory.deployed()
    let warehouse = await Warehouse.deployed()

    // All required contracts deployed, deploy the updated registry
    await deployer.deploy(Registry, factory.address, warehouse.address)

    // Perform access logic updates
    let registry = await Registry.deployed()
    warehouse.addAllowedSender(registry.address)
  })
}
