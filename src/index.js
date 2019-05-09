var package = require("./package.json")

// Import the necessary json files from Truffle build
var OrionemFactory = require("./build/contracts/OrioneumFactory")
var OrionemRegistry = require("./build/contracts/OrioneumRegistry")



// Export basic information
exports.Orioneum = {
  "version:" package.version
}

// Export the structures to npm package
exports.OrioneumFactory = OrionemFactory
exports.OrioneumRegistry = OrionemRegistry
