var pkg = require("../package.json")

// Import all exported functions from other files
import Warehouse from '../build/contracts/Warehouse.json'
import Factory from '../build/contracts/Factory.json'
import Registry from '../build/contracts/Registry.json'

// Export basic information and contracts
Orioneum = {
  "version": pkg.version,
  "contracts": {
    Warehouse,
    Factory,
    Registry
  },
}
exports.Orioneum = Orioneum
export { getBreakdownFromMultihash, getMultihashFromBreakdown } from './multihash.js'
