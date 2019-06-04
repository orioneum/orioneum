require('@babel/register')
require("regenerator-runtime/runtime")

// Get all keys and ids from environment variables
const HDWalletProvider = require("truffle-hdwallet-provider")
const INFURA_API_KEY = process.env.INFURA_API_KEY
const MNEMONIC = process.env.MNEMONIC

module.exports = {

  networks: {

    // Run ganache-cli and use this network for dev and testing purposes
    development: {
     host: "127.0.0.1",     // Localhost
     port: 8545,            // Standard Ethereum port
     network_id: "*",       // Any network (default: none)
     gas: 200000000         // Default is 4712388
    },

    // Beta network
    ropsten: {
      network_id: 3,           // Ropsten's id
      gas: 5500000,            // Ropsten has a lower block limit than mainnet
      // confirmations: 2,       // # of confs to wait between deployments. (default: 0)
      // timeoutBlocks: 200,     // # of blocks before a deployment times out  (minimum/default: 50)
      // skipDryRun: true,       // Skip dry run before migrations? (default: false for public nets )

      provider: new HDWalletProvider(MNEMONIC, 'https://ropsten.infura.io/v3/' + INFURA_API_KEY),
    },
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.5.8",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  }
}
