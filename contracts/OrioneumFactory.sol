pragma solidity 0.5.8;

import "./oads/OAD1.sol";
import "./oads/OAD2.sol";
import "./OrioneumWarehouse.sol";

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   The Orioneum Factory. This contract creates smart contracts representing OADs and
*   other functions like managing available types.
*   Supported types in this version:
*   1) OAD1
*   2) OAD2
*
*   @title Orioneum Factory
*   @author Tore Stenbock
*/
contract OrioneumFactory is Ownable {

  // Maintain mapping of available assets
  mapping(uint => bool) private availableOADTypes;
  uint constant oad1Type = 1;
  uint constant oad2Type = 2;
  uint constant totalOADTypes = 2;

  // Orioneum Contracts (zero initializied)
  OrioneumWarehouse private warehouse = OrioneumWarehouse(0);



  // Construct the Factory contract with some requirements
  constructor(address _warehouseAddr) Ownable() public {
    warehouse = OrioneumWarehouse(_warehouseAddr);
    require(owner() == warehouse.owner());

    // Initialize the availableOADTypes mapping
    availableOADTypes[oad1Type] = true;
    availableOADTypes[oad2Type] = true;
  }



  // Get all the available OAD type codes
  function getAvailableOADTypeCodes() public pure returns(uint[] memory) {
    uint[] memory _availableOADTypeCodes = new uint[](totalOADTypes);
    _availableOADTypeCodes[0] = oad1Type;
    _availableOADTypeCodes[1] = oad2Type;

    return(_availableOADTypeCodes);
  }

  // Get the base title and description of the available assets
  function getOADTypeBaseInformation(uint _oad_type) public view returns(string memory, string memory) {
    require(availableOADTypes[_oad_type]);

    if (_oad_type == oad1Type) {
      return(
        "Item for sale",
        "A generic item with a non-zero sell value and with basic owner information."
      );
    }
    else if (_oad_type == oad2Type) {
      return(
        "Discount code",
        "A discount code with a zero sell value and with basic owner information."
      );
    }

    // This should never happen
    return("Error", "Something very wrong happened. This should not happen.");
  }
}
