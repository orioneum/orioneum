const truffleAssert = require('truffle-assertions')

const Utils = artifacts.require("../contracts/Utils")
const Warehouse = artifacts.require("../contracts/Warehouse")
const Registry = artifacts.require("../contracts/Registry")
const OAD1 = artifacts.require("../contracts/oads/OAD1")



contract('Registry', async (accounts) => {

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

  beforeEach("Deploying Warehouse, Utils, and Registry", async () => {
    utils = await Utils.new()
    warehouse = await Warehouse.new()
    registry = await Registry.new(utils.address, warehouse.address)

    warehouse.addAllowedSender(registry.address)
  })

  /****************************************************************************/
  /****                           Constructor                              ****/
  /****************************************************************************/

  it("constructor(): Check invalid caller.", async () => {
    await truffleAssert.reverts(Registry.new(utils.address, warehouse.address, {from: rand_addr1}),
      "Registry owner must be same as Utils and Warehouse owner.")
  })

  it("constructor(): Check invalid Utils address.", async () => {
    await truffleAssert.reverts(Registry.new(rand_addr1, warehouse.address))
  })

  it("constructor(): Check invalid Warehouse address.", async () => {
    await truffleAssert.reverts(Registry.new(utils.address, rand_addr1))
  })

  /****************************************************************************/
  /****                     getAvailableOADTypeCodes()                     ****/
  /****************************************************************************/

  it("getAvailableOADTypeCodes(): Check returned types.", async () => {
    const expected_oad_types = [1,2] // According to OPDs
    const given_oad_types = await registry.getAvailableOADTypeCodes()

    while(given_oad_types.length > 0) {
      const type = given_oad_types.shift().toNumber()

      assert.ok(expected_oad_types.includes(type), "Did not expect returned oadType='" + type + "'")
      expected_oad_types.splice(expected_oad_types.indexOf(type), 1)
    }
    assert.equal(expected_oad_types.length, 0, "Returned type list did not match expected.")
  })

  /****************************************************************************/
  /****                    getOADTypeBaseInformation()                     ****/
  /****************************************************************************/

  it("getOADTypeBaseInformation(): Check invalid type.", async () => {
    const oad_type_0 = 0
    const nonexistant_oad_type = 999999

    await truffleAssert.reverts(registry.getOADTypeBaseInformation(oad_type_0));
    await truffleAssert.reverts(registry.getOADTypeBaseInformation(nonexistant_oad_type));
  })

  it("getOADTypeBaseInformation(): Check base info.", async () => {
    const available_oad_types = await registry.getAvailableOADTypeCodes()

    available_oad_types.forEach(async (oadType) => {
      const oad = await registry.getOADTypeBaseInformation(oadType)
      assert.equal(Object.keys(oad).length, 2, "BaseOAD information must have title and description")

      const base_title = oad[0]
      const base_description = oad[1]
      assert.ok((base_title.length >= 8 && base_title.length <= 32), // According to OPDs
        "BaseOAD title must be at least 8 characters and no more than 32 characters.")
      assert.ok(base_description.length >= 32 && base_description.length <= 256, // According to OPDs
        "BaseOAD description must be at least 32 characters and no more than 256 characters.")
    })
  })

  /****************************************************************************/
  /****                           register()                               ****/
  /****************************************************************************/

  it("register(): Register existing OAD1.", async () => {
    const title = "a".repeat(16)
    const description = "b".repeat(128)
    const _oad1 = await OAD1.new(title, description, true, {from: user1})

    const tx1 = await registry.register(_oad1.address, {from: user1})
    const tx2 = await registry.register(_oad1.address, {from: user1})

    await truffleAssert.eventEmitted(tx1, "Orioneum_REGISTER_NEW")
    await truffleAssert.eventNotEmitted(tx2, "Orioneum_REGISTER_NEW")
  })

  /****************************************************************************/
  /****                         getOAD1Values()                            ****/
  /****************************************************************************/

  it("getOAD1Values(): Check if invalid OAD type.", async () => {
    await truffleAssert.reverts(registry.getOAD1Values(rand_addr1, {from: user1}))
  })
})
