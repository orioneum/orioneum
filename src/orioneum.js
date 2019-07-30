import Package from '../package.json'
import Warehouse from '../build/contracts/Warehouse.json'
import Orioneum from '../build/contracts/Orioneum.json'

import { getBreakdownFromMultihash, getMultihashFromBreakdown } from './multihash.js'



// Export basic information and contracts
exports.Orioneum = {
  // Package information
  "version": Package.version,
  // Truffle compiled Smart Contracts
  "contracts": {
    Warehouse,
    Orioneum
  },
  // Helper functions
  getBreakdownFromMultihash,
  getMultihashFromBreakdown
}
