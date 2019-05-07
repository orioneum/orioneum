const OrioneumWarehouse = artifacts.require("./OrioneumWarehouse.sol")
const OrioneumFactory = artifacts.require("./OrioneumFactory.sol")

const OrioneumRegistry = artifacts.require("./OrioneumRegistry.sol")



module.exports = function(deployer) {
  // Make async to enforce Promise chaining
  deployer.then(async() => {

    // Get handle of Warehouse contract
    let warehouse = await OrioneumWarehouse.deployed()
    let factory = await OrioneumFactory.deployed()

    // All required contracts deployed, deploy the updated registry
    await deployer.deploy(OrioneumRegistry, warehouse.address, factory.address)
  })
}
