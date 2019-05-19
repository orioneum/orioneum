pragma solidity ^0.5.7;

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
  uint private oad1_type = 1;
  uint private oad2_type = 2;

  // Orioneum Contracts (zero initializied)
  OrioneumWarehouse private warehouse = OrioneumWarehouse(0);



  // Construct the Factory contract with some requirements
  constructor(address _warehouseAddr) Ownable() public {
    warehouse = OrioneumWarehouse(_warehouseAddr);
    require(owner() == warehouse.owner());

    // Initialize the availableOADTypes mapping
    availableOADTypes[oad1_type] = true;
    availableOADTypes[oad2_type] = true;
  }



  // Get the base title and description of the available assets
  function getOADTypeBaseInformation(uint _oad_type) public view returns(string memory, string memory) {
    require(availableOADTypes[_oad_type]);

    if (_oad_type == oad1_type) {
      return(
        "Item for sale",
        "A generic item with a non-zero sell value and with basic owner information."
      );
    }
    else if (_oad_type == oad2_type) {
      return(
        "Discount code",
        "A discount code with a zero sell value and with basic owner information."
      );
    }

    // This should never happen
    return("Error", "Something very wrong happened. This should not happen.");
  }
}
