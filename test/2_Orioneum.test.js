const truffleAssert = require('truffle-assertions')

const Warehouse = artifacts.require("../contracts/Warehouse")
const Orioneum = artifacts.require("../contracts/Orioneum")
const BaseOAD = artifacts.require("../contracts/BaseOAD")

import { getBreakdownFromMultihash, getMultihashFromBreakdown } from '../src/multihash.js'



contract('Orioneum', async (accounts) => {

  var warehouse
  var orioneum

  // Define some users
  const originator = accounts[0] // This is the base Registry address
  const rand_addr1 = accounts[1]
  const rand_addr2 = accounts[2]
  const user1 = accounts[3]
  const user2 = accounts[4]
  const user3 = accounts[5]



  /****************************************************************************/
  /****                           Constructor                              ****/
  /****************************************************************************/

  describe("constructor()", () => {

    before("Deploying Warehouse and Orioneum", async () => {
      warehouse = await Warehouse.new()
      orioneum = await Orioneum.new(warehouse.address)

      warehouse.addAllowedSender(orioneum.address)
    })

    it("Check invalid caller.", async () => {
      await truffleAssert.reverts(Orioneum.new(warehouse.address, {from: rand_addr1}),
        "Registry owner must be same as Factory and Warehouse owner.")
    })

    it("Check invalid Warehouse address.", async () => {
      await truffleAssert.reverts(Orioneum.new(rand_addr1))
    })

  })

  /****************************************************************************/
  /****                           register()                               ****/
  /****************************************************************************/

  describe("register()", () => {

    beforeEach("Deploying Warehouse and Orioneum", async () => {
      warehouse = await Warehouse.new()
      orioneum = await Orioneum.new(warehouse.address)

      warehouse.addAllowedSender(orioneum.address)
    })

    it("Check create ownership.", async () => {
      const ipfs_hash = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U8'

      const tx1 = await orioneum.register(1, true, ipfs_hash, {from: user1})
      await truffleAssert.eventEmitted(tx1, "Orioneum_REGISTER_NEW", async (ev) => {
        const baseOAD = await BaseOAD.at(ev.oad_addr)
        const _owner = await baseOAD.owner()
        return (_owner === user1)
      }, "Asset was not created with correct owner")
      await truffleAssert.eventNotEmitted(tx1, "Orioneum_REGISTER_FAILED")
    })

  })

  /****************************************************************************/
  /****                             query()                                ****/
  /****************************************************************************/

  describe("query()", () => {

    beforeEach("Deploying Warehouse and Orioneum", async () => {
      warehouse = await Warehouse.new()
      orioneum = await Orioneum.new(warehouse.address)

      warehouse.addAllowedSender(orioneum.address)
    })

    it("Check query on type.", async () => {
      const ipfs_hash1 = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U1'
      const ipfs_hash2 = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U2'

      // Insert an asset
      const tx1 = await orioneum.register(1, true, ipfs_hash1, {from: user1})
      await truffleAssert.eventEmitted(tx1, "Orioneum_REGISTER_NEW")

      // Insert another
      const tx2 = await orioneum.register(2, true, ipfs_hash2, {from: user2})
      await truffleAssert.eventEmitted(tx2, "Orioneum_REGISTER_NEW")

      // Check query on type
      const oads = await orioneum.queryByType(2, false, {from: user1})
      assert.equal(oads.length, 1, "Query on type returns invalid entries.")
    })

    it("Check query on owner.", async () => {
      const ipfs_hash1 = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U1'
      const ipfs_hash2 = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U2'

      // Insert an asset
      const tx1 = await orioneum.register(1, true, ipfs_hash1, {from: user1})
      await truffleAssert.eventEmitted(tx1, "Orioneum_REGISTER_NEW")

      // Insert another
      const tx2 = await orioneum.register(2, true, ipfs_hash2, {from: user2})
      await truffleAssert.eventEmitted(tx2, "Orioneum_REGISTER_NEW")

      // Check query on owner
      const oads = await orioneum.queryByOwner(user1, true, {from: user1})
      assert.equal(oads.length, 1, "Query on owner returns invalid entries.")
    })

  })

})
