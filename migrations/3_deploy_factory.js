const OrioneumWarehouse = artifacts.require("./OrioneumWarehouse.sol")

const OrioneumFactory = artifacts.require("./OrioneumFactory.sol")

module.exports = function(deployer) {

//   deployer.deploy(OrioneumFactory)

  // Make async to enforce Promise chaining
  deployer.then(async() => {

    // Get handle of Warehouse contract
    let warehouse = await OrioneumWarehouse.deployed()

    // All required contracts deployed, deploy the updated factory
    await deployer.deploy(OrioneumFactory, warehouse.address)
  })
}
