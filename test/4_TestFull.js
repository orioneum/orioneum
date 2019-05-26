const truffleAssert = require('truffle-assertions')

const Utils = artifacts.require("../contracts/Utils")
const Warehouse = artifacts.require("../contracts/Warehouse")
const Registry = artifacts.require("../contracts/Registry")
const OAD1 = artifacts.require("../contracts/oads/OAD1")



contract('Full run-through', async (accounts) => {

  var utils
  var warehouse
  var registry

  // Define some users
  const originator = accounts[0] // This is the base Registry address
  const rand_addr1 = accounts[1]
  const rand_addr2 = accounts[2]
  const user1 = accounts[3]
  const user2 = accounts[4]
  const user3 = accounts[5]

  /****************************************************************************/
  /****                             BEFORE                                 ****/
  /****************************************************************************/

  before("Deploying Warehouse, Utils, and Registry", async () => {
    utils = await Utils.new()
    warehouse = await Warehouse.new()
    registry = await Registry.new(utils.address, warehouse.address)

    warehouse.addAllowedSender(registry.address)
  })

  /****************************************************************************/
  /****                        Final success cases                         ****/
  /****************************************************************************/

  it("Create, register, get, update, and deregister.", async () => {
    const title = "a".repeat(16)
    const description = "b".repeat(128)

    // Create and register an OAD
    const tx1 = await registry.createOAD1AndRegister("1"+title, "1"+description, true, {from: user1})
    await truffleAssert.eventEmitted(tx1, "Orioneum_CREATE_OAD1")
    await truffleAssert.eventEmitted(tx1, "Orioneum_REGISTER_NEW")

    // Do a few more
    const tx2 = await registry.createOAD1AndRegister("2"+title, "2"+description, true, {from: user1})
    const tx3 = await registry.createOAD1AndRegister("3"+title, "3"+description, true, {from: user2})

    // Get the values from an OAD1 and check if correct
    const oads_addr = await registry.getByOwner(user1)
    const vals = await registry.getOAD1Values(oads_addr[0])
    assert.equal(vals[0], "1"+title)
    assert.equal(vals[1], "1"+description)
  })
})
