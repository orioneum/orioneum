
contract('Test Information', async (accounts) => {
  // Define some users
  const originator = accounts[0] // This is the base Orioneum address
  const rand_addr1 = accounts[1]
  const rand_addr2 = accounts[2]
  const user1 = accounts[3]
  const user2 = accounts[4]
  const user3 = accounts[5]

  // Print out available account information (useful for truffle test printouts)
  console.log("   Addresses used for testing:")
  console.log("   originator:    " + originator)
  console.log("   rand_addr1:    " + rand_addr1)
  console.log("   rand_addr2:    " + rand_addr2)
  console.log("   user1:         " + user1)
  console.log("   user2:         " + user2)
  console.log("   user3:         " + user3)
})
