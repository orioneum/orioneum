import Package from '../package.json'
import Orioneum from '../build/contracts/Orioneum.json'



// Export basic information and contracts
exports.Orioneum = {
  // Package information
  "version": Package.version,
  // Truffle compiled Smart Contracts
  "contracts": {
    Orioneum
  }
}
