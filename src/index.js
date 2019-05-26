var pkg = require("../package.json")

// Import the necessary json files from Truffle build
var Warehouse = require("../build/contracts/Warehouse")
var Registry = require("../build/contracts/Registry")



// Export basic information
// TODO: Better way than this
exports.Orioneum = {
  "version": pkg.version,
  "contracts": {
    Warehouse,
    Registry
  },
}
