var pkg = require("../package.json")

// Import the necessary json files from Truffle build
var Factory = require("../build/contracts/OrioneumFactory")
var Registry = require("../build/contracts/OrioneumRegistry")



// Export basic information
// TODO: Better way than this
exports.Orioneum = {
  "version": pkg.version,
  "contracts": {
    Factory,
    Registry
  },
}
