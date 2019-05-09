var package = require("../package.json")

// Import the necessary json files from Truffle build
var orionemFactory = require("../build/contracts/OrioneumFactory")
var orionemRegistry = require("../build/contracts/OrioneumRegistry")



// Export basic information
// TODO: Better way than this
exports.Orioneum = {
  "version": package.version
}

// Export the structures to npm package
exports.OrioneumFactory = orionemFactory
exports.OrioneumRegistry = orionemRegistry
