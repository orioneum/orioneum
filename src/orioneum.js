import {version} from '../package.json'
import Orioneum from '../build/contracts/Orioneum.json'



// Export basic information and contracts
exports.Orioneum = {
  // Package information
  "version": version,
  "availableOADs": [1]
  // Truffle compiled Smart Contracts
  "contracts": {
    Orioneum
  }
}
