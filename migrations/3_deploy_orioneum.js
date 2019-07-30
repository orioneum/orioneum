const Warehouse = artifacts.require("./Warehouse.sol")
const Orioneum = artifacts.require("./Orioneum.sol")



module.exports = function(deployer) {
  // Make async to enforce Promise chaining
  deployer.then(async() => {

    // Get handle Warehouse contract and deploy the Registry
    const warehouse = await Warehouse.deployed()
    await deployer.deploy(Orioneum, warehouse.address)

    // Perform access logic updates
    const orioneum = await Orioneum.deployed()
    warehouse.addAllowedSender(orioneum.address)
  })
}
