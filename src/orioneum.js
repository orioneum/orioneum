import Package from '../package.json'
import Warehouse from '../build/contracts/Warehouse.json'
import Factory from '../build/contracts/Factory.json'
import Registry from '../build/contracts/Registry.json'

import { getBreakdownFromMultihash, getMultihashFromBreakdown } from './multihash.js'



// Export basic information and contracts
exports.Orioneum = {
  // Package information
  "version": Package.version,
  // Truffle compiled Smart Contracts
  "contracts": {
    Warehouse,
    Factory,
    Registry
  },
  // Helper functions
  getBreakdownFromMultihash,
  getMultihashFromBreakdown
}
