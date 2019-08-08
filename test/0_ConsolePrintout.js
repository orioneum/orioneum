
contract('Test Information', async (accounts) => {
  // Define some users
  const zero_addr = '0x0000000000000000000000000000000000000000'
  const originator_addr = accounts[0] // This is the base Registry address
  const rand1_addr = accounts[1]
  const rand2_addr = accounts[2]
  const user1_addr = accounts[3]
  const user2_addr = accounts[4]
  const user3_addr = accounts[5]

  // Print out available account information (useful for truffle test printouts)
  console.log("   Addresses used for testing:")
  console.log("   Zero Addr:     " + zero_addr)
  console.log("   Originator:    " + originator_addr)
  console.log("   Rand Addr1:    " + rand1_addr)
  console.log("   Rand Addr2:    " + rand2_addr)
  console.log("   User1 Addr:    " + user1_addr)
  console.log("   User2 Addr:    " + user2_addr)
  console.log("   User3 Addr:    " + user3_addr)
})
