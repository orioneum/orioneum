
// Get all keys and ids from environment variables
const HDWalletProvider = require("truffle-hdwallet-provider")
const INFURA_API_KEY = process.env.INFURA_API_KEY
const MNEMONIC = process.env.MNEMONIC

module.exports = {

  networks: {

    // development: {
    //  host: "127.0.0.1",     // Localhost (default: none)
    //  port: 8545,            // Standard Ethereum port (default: none)
    //  network_id: "*",       // Any network (default: none)
    // },

    ropsten: {
      network_id: 3,        // Ropsten's id
      gas: 5500000,         // Ropsten has a lower block limit than mainnet
      // confirmations: 2,     // # of confs to wait between deployments. (default: 0)
      // timeoutBlocks: 200,   // # of blocks before a deployment times out  (minimum/default: 50)
      // skipDryRun: true      // Skip dry run before migrations? (default: false for public nets )

      // host: "10.8.0.1",     // Location of Ropsten geth instance (Tunnel end-point)
      // port: 8545,           // Port of Ropsten geth instance (LAN node)

      provider: new HDWalletProvider(MNEMONIC, 'https://ropsten.infura.io/v3/' + INFURA_API_KEY),
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
