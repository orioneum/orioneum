const truffleAssert = require('truffle-assertions')

const Warehouse = artifacts.require("../contracts/Warehouse")
const BaseOAD = artifacts.require("../contracts/BaseOAD")

import { getBreakdownFromMultihash, getMultihashFromBreakdown } from '../src/multihash.js'



contract('Warehouse', async (accounts) => {

  var warehouse;

  // Define some users
  const originator = accounts[0] // This is the coinbase Orioneum address
  const rand_addr1 = accounts[1]
  const rand_addr2 = accounts[2]
  const user1 = accounts[3]
  const user2 = accounts[4]
  const user3 = accounts[5]



  /****************************************************************************/
  /****                              add()                                 ****/
  /****************************************************************************/

  describe("add()", () => {

    before("Deploying Warehouse", async () => {
      warehouse = await Warehouse.new()
      warehouse.addAllowedSender(originator)
    })

    it("Check invalid caller." , async () => {
      const ipfs_hash = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U8'
      const { digest, hash_function, size } = getBreakdownFromMultihash(ipfs_hash)
      const oad = await BaseOAD.new(1, true, digest, hash_function, size, {from: user1})

      await truffleAssert.reverts(warehouse.add(oad.address, {from: rand_addr1}))
    })

    it("Check invalid OAD address.", async () => {
      await truffleAssert.reverts(warehouse.add(rand_addr1));
    })

    it("Check adding existing.", async () => {
      const ipfs_hash = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U8'
      const { digest, hash_function, size } = getBreakdownFromMultihash(ipfs_hash)
      const oad = await BaseOAD.new(1, true, digest, hash_function, size, {from: user1})

      const tx1 = await warehouse.add(oad.address);
      const tx2 = await warehouse.add(oad.address);

      await truffleAssert.eventEmitted(tx1, "Orioneum_ADD_SUCCESS")
      await truffleAssert.eventEmitted(tx2, "Orioneum_ADD_EXISTS")
    })

  })

  /****************************************************************************/
  /****                           getByOwners()                            ****/
  /****************************************************************************/

  describe("getByOwner()", () => {

    before("Deploying Warehouse", async () => {
      warehouse = await Warehouse.new()
      warehouse.addAllowedSender(originator)
    })

    it("Check invalid caller." , async () => {
      const ipfs_hash = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U8'
      const { digest, hash_function, size } = getBreakdownFromMultihash(ipfs_hash)
      const oad = await BaseOAD.new(1, true, digest, hash_function, size, {from: user1})
      await warehouse.add(oad.address)

      await truffleAssert.reverts(warehouse.getByOwner(user1, {from: rand_addr1}))
    })

    it("Check non-existing OAD by owner.", async () => {
      const ipfs_hash = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U8'
      const { digest, hash_function, size } = getBreakdownFromMultihash(ipfs_hash)
      const oad = await BaseOAD.new(1, true, digest, hash_function, size, {from: user1})
      await warehouse.add(oad.address)

      const _result = await warehouse.getByOwner(rand_addr1)
      assert.equal(_result.length, 0, "Returned oad with non-existant owner.")

      await truffleAssert.passes(warehouse.getByOwner(user1))
    })

  })

  /****************************************************************************/
  /****                            getByType()                             ****/
  /****************************************************************************/

  describe("getByType()", () => {

    before("Deploying Warehouse", async () => {
      warehouse = await Warehouse.new()
      warehouse.addAllowedSender(originator)
    })

    it("Check invalid caller." , async () => {
      const ipfs_hash = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U8'
      const { digest, hash_function, size } = getBreakdownFromMultihash(ipfs_hash)
      const oad = await BaseOAD.new(1, true, digest, hash_function, size, {from: user1})
      await warehouse.add(oad.address)

      await truffleAssert.reverts(warehouse.getByType(user1, {from: rand_addr1}))
    })

    it("Check non-existing OAD by type.", async () => {
      const ipfs_hash = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U8'
      const { digest, hash_function, size } = getBreakdownFromMultihash(ipfs_hash)
      const oad = await BaseOAD.new(1, true, digest, hash_function, size, {from: user1})
      await warehouse.add(oad.address)

      const _result = await warehouse.getByType(2) // OAD2
      assert.equal(_result.length, 0, "Returned oad with non-existant owner.")

      await truffleAssert.passes(warehouse.getByType(1)) // OAD1
    })

  })
})
