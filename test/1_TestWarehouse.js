const truffleAssert = require('truffle-assertions')

const Warehouse = artifacts.require("../contracts/Warehouse")
const BaseOAD = artifacts.require("../contracts/BaseOAD")
const OAD1 = artifacts.require("../contracts/oads/OAD1")



contract('Warehouse', async (accounts) => {

  var warehouse;

  // Define some users
  const originator = accounts[0] // This is the base Orioneum address
  const rand_addr1 = accounts[1]
  const rand_addr2 = accounts[2]
  const user1 = accounts[3]
  const user2 = accounts[4]
  const user3 = accounts[5]

  // Print out available account information (useful for truffle test printouts)
  console.log("Addresses used for testing:")
  console.log("originator:    " + originator)
  console.log("rand_addr1:    " + rand_addr1)
  console.log("rand_addr2:    " + rand_addr2)
  console.log("user1:         " + user1)
  console.log("user2:         " + user2)
  console.log("user3:         " + user3)

  /****************************************************************************/
  /****                             BEFORE                                 ****/
  /****************************************************************************/

  beforeEach("Deploying Warehouse", async () => {
    warehouse = await Warehouse.new()
    warehouse.addAllowedSender(originator)
  })

  /****************************************************************************/
  /****                              add()                                 ****/
  /****************************************************************************/

  it("add(): Check invalid caller." , async () => {
    const title = "a".repeat(16)
    const description = "b".repeat(128)
    const _oad1 = await OAD1.new(title, description, true, {from: user1})

    await truffleAssert.reverts(warehouse.add(_oad1.address, {from: rand_addr1}))
  })

  it("add(): Check invalid OAD address.", async () => {
    await truffleAssert.reverts(warehouse.add(rand_addr1));
  })

  it("add(): Check invalid OAD type.", async () => {
    const _oad1 = await BaseOAD.new({from: user1})
    await truffleAssert.reverts(warehouse.add(_oad1.address));
  })

  it("add(): Add existing.", async () => {
    const title = "a".repeat(16)
    const description = "b".repeat(128)
    const _oad1 = await OAD1.new(title, description, true, {from: user1})

    const tx1 = await warehouse.add(_oad1.address);
    const tx2 = await warehouse.add(_oad1.address);

    await truffleAssert.eventEmitted(tx1, "Orioneum_ADD_SUCCESS")
    await truffleAssert.eventEmitted(tx2, "Orioneum_ADD_EXISTS")
  })

  /****************************************************************************/
  /****                              get()                                 ****/
  /****************************************************************************/

  it("get(): Check invalid caller." , async () => {
    const title = "a".repeat(16)
    const description = "b".repeat(128)
    const _oad1 = await OAD1.new(title, description, true)
    await warehouse.add(_oad1.address)

    await truffleAssert.reverts(warehouse.get(user1, {from: rand_addr1}))
  })

  it("get(): Check invalid OAD address.", async () => {
    const title = "a".repeat(16)
    const description = "b".repeat(128)
    const _oad1 = await OAD1.new(title, description, true)
    await warehouse.add(_oad1.address)

    const _result = await warehouse.get(rand_addr1)

    await truffleAssert.passes(warehouse.get(user1))
    assert.equal(_result.length, 0, "Returned oad with non-existant owner.")
  })

  // /****************************************************************************/
  // /****                         Final Success Case                         ****/
  // /****************************************************************************/
  //
  // it("Full Success case pass.", async () => {
  //   const title = "a".repeat(16)
  //   const description = "b".repeat(128)
  //   const _oad1 = await OAD1.new(title+"1", description+"1", true, {from: user1})
  //   const _oad2 = await OAD1.new(title+"2", description+"2", false, {from: user1})
  //   const _oad3 = await OAD1.new(title+"3", description+"3", false, {from: user2})
  //
  //   // Add a couple of mocked assets
  //   await truffleAssert.passes(warehouse.add(_oad1.address))
  //   await truffleAssert.passes(warehouse.add(_oad2.address))
  //   await truffleAssert.passes(warehouse.add(_oad3.address))
  //
  //   const _result1 = await warehouse.get(user1)
  //   const _result2 = await warehouse.get(user2)
  //   assert.equal(_result1.length, 2, "Got " + _result1.length + " OADs but expected 2 for user1")
  //   assert.equal(_result2.length, 1, "Got " + _result2.length + " OADs but expected 1 for user2")
  // })
})
