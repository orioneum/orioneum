const truffleAssert = require('truffle-assertions')

const BaseOAD = artifacts.require("../contracts/BaseOAD")

import { getBreakdownFromMultihash, getMultihashFromBreakdown } from '../src/multihash.js'



contract('BaseOAD', async (accounts) => {

  // Define some users
  const originator = accounts[0] // This is the base Orioneum address
  const rand_addr1 = accounts[1]
  const rand_addr2 = accounts[2]
  const user1 = accounts[3]
  const user2 = accounts[4]
  const user3 = accounts[5]



  /****************************************************************************/
  /****                           Constructor                              ****/
  /****************************************************************************/

  describe("constructor()", () => {

    it("Check IPFS hash storage.", async () => {
      const ipfs_hash = 'QmahqCsAUAaw7zMv6P6Ae8PjCTk7taQA6FgGQLnWdKG7U8'
      const { digest, hash_function, size } = getBreakdownFromMultihash(ipfs_hash)
      const oad = await BaseOAD.new(1, true, digest, hash_function, size, {from: user1})
      const result = await oad.getIPFSMultihash()

      assert.equal(result[0], digest, "Hash digest not matching")
      assert.equal(result[1], hash_function, "Hash function not matching")
      assert.equal(result[2], size, "Hash size not matching")

      // And also make sure the package functions can convert back
      assert.equal(ipfs_hash, getMultihashFromBreakdown(result[0], result[1], result[2]))
    })

  })

})
