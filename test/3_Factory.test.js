const truffleAssert = require('truffle-assertions')

const Factory = artifacts.require("../contracts/Factory")

import { getBreakdownFromMultihash, getMultihashFromBreakdown } from '../src/multihash.js'



contract('Factory', async (accounts) => {

  var factory

  // Define some users
  const originator = accounts[0] // This is the base Orioneum address
  const rand_addr1 = accounts[1]
  const rand_addr2 = accounts[2]
  const user1 = accounts[3]
  const user2 = accounts[4]
  const user3 = accounts[5]



  /****************************************************************************/
  /****                           Create OADs                              ****/
  /****************************************************************************/

  describe("create()", () => {

    before("Deploying Factory", async () => {
      factory = await Factory.new()
    })

    it("Check invalid OAD type.", async () => {
      const oad_type_0 = 0
      const nonexistant_oad_type = 999999
      const ipfs_hash = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U8'
      const { digest, hash_function, size } = getBreakdownFromMultihash(ipfs_hash)

      await truffleAssert.reverts(factory.create(oad_type_0, true, digest, hash_function, size, {from: user1}),
        "Given OAD type invalid.")
      await truffleAssert.reverts(factory.create(nonexistant_oad_type, true, digest, hash_function, size, {from: user1}),
        "Given OAD type invalid.")
    })

    // it("Check ownership transferred.", async () => {
    //   const ipfs_hash = 'QmahqCsAUAw7zMv6P6Ae8PjCTck7taQA6FgGQLnWdKG7U8'
    //   const { digest, hash_function, size } = getBreakdownFromMultihash(ipfs_hash)
    //
    //   const tx1 = await factory.create(1, true, digest, hash_function, size, {from: user1})
    //   await truffleAssert.eventEmitted(tx1, "OwnershipTransferred", (ev) => {
    //     // First it's set to factory address then transferred over to msg.sender
    //     console.log(ev[1])
    //     console.log(factory.address)
    //     assert.equal(ev[1] === factory.address, "OAD ownership was not transferred.")
    //   })
    // })

  })

  /****************************************************************************/
  /****                     getAvailableOADTypeCodes()                     ****/
  /****************************************************************************/

  describe("getAvailableOADTypeCodes()", () => {

    before("Deploying Factory", async () => {
      factory = await Factory.new()
    })

    it("Check returned types.", async () => {
      const expected_oad_types = [1,2] // According to OPDs
      const given_oad_types = await factory.getAvailableOADTypeCodes()

      while(given_oad_types.length > 0) {
        const type = given_oad_types.shift().toNumber()

        assert.ok(expected_oad_types.includes(type), "Did not expect returned oadType='" + type + "'")
        expected_oad_types.splice(expected_oad_types.indexOf(type), 1)
      }
      assert.equal(expected_oad_types.length, 0, "Returned type list did not match expected.")
    })

  })

  /****************************************************************************/
  /****                    getOADTypeBaseInformation()                     ****/
  /****************************************************************************/

  describe("getOADTypeBaseInformation()", () => {

    before("Deploying Factory", async () => {
      factory = await Factory.new()
    })

    it("Check base info format.", async () => {
      const available_oad_types = await factory.getAvailableOADTypeCodes()

      available_oad_types.forEach(async (oadType) => {
        const oad = await factory.getOADTypeBaseInformation(oadType)
        assert.equal(Object.keys(oad).length, 2, "BaseOAD information must have title and description")

        const base_title = oad[0]
        const base_description = oad[1]
        assert.ok((base_title.length >= 8 && base_title.length <= 32), // According to OPDs
          "BaseOAD title must be at least 8 characters and no more than 32 characters.")
        assert.ok(base_description.length >= 32 && base_description.length <= 256, // According to OPDs
          "BaseOAD description must be at least 32 characters and no more than 256 characters.")
      })
    })

  })

})
