const truffleAssert = require('truffle-assertions')

const Warehouse = artifacts.require("../contracts/Warehouse")
const Orioneum = artifacts.require("../contracts/Orioneum")
const BaseOAD = artifacts.require("../contracts/BaseOAD")

import { getBreakdownFromMultihash, getMultihashFromBreakdown } from '../src/multihash.js'



contract('Orioneum', async (accounts) => {

  var warehouse
  var orioneum

  // Define some users
  const zero_addr = '0x0000000000000000000000000000000000000000'
  const originator_addr = accounts[0] // This is the base Registry address
  const rand1_addr = accounts[1]
  const rand2_addr = accounts[2]
  const user1_addr = accounts[3]
  const user2_addr = accounts[4]
  const user3_addr = accounts[5]



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
      await truffleAssert.reverts(Orioneum.new(warehouse.address, {from: rand1_addr}),
        "Registry owner must be same as Factory and Warehouse owner.")
    })

    it("Check invalid Warehouse address.", async () => {
      await truffleAssert.reverts(Orioneum.new(rand1_addr))
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

      const tx1 = await orioneum.register(1, true, ipfs_hash, {from: user1_addr})
      await truffleAssert.eventEmitted(tx1, "Orioneum_REGISTER_NEW", async (ev) => {
        const baseOAD = await BaseOAD.at(ev.oad_addr)
        const _owner = await baseOAD.owner()
        return (_owner === user1_addr)
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

    it("Check query on type filtering.", async () => {
      const ipfs_hash1 = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U1'
      const ipfs_hash2 = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U2'

      // Register an asset
      const tx1 = await orioneum.register(1, true, ipfs_hash1, {from: user1_addr})
      await truffleAssert.eventEmitted(tx1, "Orioneum_REGISTER_NEW")

      // Register another
      const tx2 = await orioneum.register(2, true, ipfs_hash2, {from: user2_addr})
      await truffleAssert.eventEmitted(tx2, "Orioneum_REGISTER_NEW")

      // Check query on type
      const oads = await orioneum.queryByType(2, false, {from: user1_addr})
      assert.equal(oads.length, 1, "Query on type returns invalid entries.")
    })

    it("Check query on owner filtering.", async () => {
      const ipfs_hash1 = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U1'
      const ipfs_hash2 = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U2'

      // Insert an asset
      const tx1 = await orioneum.register(1, true, ipfs_hash1, {from: user1_addr})
      await truffleAssert.eventEmitted(tx1, "Orioneum_REGISTER_NEW")

      // Insert another
      const tx2 = await orioneum.register(2, true, ipfs_hash2, {from: user2_addr})
      await truffleAssert.eventEmitted(tx2, "Orioneum_REGISTER_NEW")

      // Check query on owner
      const oads = await orioneum.queryByOwner(user1_addr, false, {from: user1_addr})
      assert.equal(oads.length, 1, "Query on owner returns invalid entries.")
    })

    it("Check query BaseOAD from invalid OAD Address.", async () => {

      // Register an asset
      const ipfs_hash1 = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U1'
      const tx1 = await orioneum.register(1, true, ipfs_hash1, {from: user1_addr})

      // Query BaseOAD on oxo address and random address
      await truffleAssert.reverts(orioneum.queryBaseOAD(zero_addr))
      await truffleAssert.reverts(orioneum.queryBaseOAD(rand1_addr))
    })

    it("Check query BaseOAD from OAD Address.", async () => {

      // Register an asset
      const ipfs_hash1 = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U1'
      const tx1 = await orioneum.register(1, true, ipfs_hash1, {from: user1_addr})

      // Check query on type and get the values
      const oads = await orioneum.queryByOwner(user1_addr, false, {from: user1_addr})
      const base_oad1 = await orioneum.queryBaseOAD(oads[0])

      // Check all the values
      assert.equal(base_oad1[0], 1, "Returned invalid type.")
      assert.equal(base_oad1[1], user1_addr, "Returned incorrect owner.")
      assert.equal(base_oad1[2], true, "Returned wrong bundleable flag.")
      assert.equal(base_oad1[3], ipfs_hash1, "Returned wrong IPFS hash.")
    })

  })

})
