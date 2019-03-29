
module.exports = {

  networks: {

    // development: {
    //  host: "127.0.0.1",     // Localhost (default: none)
    //  port: 8545,            // Standard Ethereum port (default: none)
    //  network_id: "*",       // Any network (default: none)
    // },

    ropsten: {
      host: "192.168.0.20", // Location of Ropsten geth instance (LAN node)
      port: 8546,           // Port of Ropsten geth instance (LAN node)
      network_id: 3,        // Ropsten's id
      gas: 5500000,         // Ropsten has a lower block limit than mainnet
      // confirmations: 2,     // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 200,   // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.5.7",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  }
}
