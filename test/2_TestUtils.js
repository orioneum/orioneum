const truffleAssert = require('truffle-assertions')

const Utils = artifacts.require("../contracts/Utils")



contract('Utils', async (accounts) => {

  var utils

  // Define some users
  const originator = accounts[0] // This is the base Orioneum address
  const rand_addr1 = accounts[1]
  const rand_addr2 = accounts[2]
  const user1 = accounts[3]
  const user2 = accounts[4]
  const user3 = accounts[5]

  /****************************************************************************/
  /****                             BEFORE                                 ****/
  /****************************************************************************/

  beforeEach("Deploying Utils", async () => {
    utils = await Utils.new()
  })

  /****************************************************************************/
  /****                       OAD input verifications                      ****/
  /****************************************************************************/

  it("validateOADTitle(): Check invalid title.", async () => {
    const short_title = "a".repeat(4)
    const long_title = "a".repeat(36)

    await truffleAssert.reverts(utils.validateOADTitle(short_title),
      "Title not within range of [8,32] characters")
    await truffleAssert.reverts(utils.validateOADTitle(long_title),
      "Title not within range of [8,32] characters")
  })

  it("validateOADDescription(): Check invalid description.", async () => {
    const short_description = "b".repeat(28)
    const long_description = "b".repeat(260)

    await truffleAssert.reverts(utils.validateOADDescription(short_description),
      "Description not within range of [32, 256] characters")
    await truffleAssert.reverts(utils.validateOADDescription(long_description),
      "Description not within range of [32, 256] characters")
  })
})
