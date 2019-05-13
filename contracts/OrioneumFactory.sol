pragma solidity ^0.5.7;

import "./oads/OAD1.sol";
import "./OrioneumWarehouse.sol";

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   The Orioneum Factory. This contract creates smart contracts representing OADs and
*   other functions like managing available types.
*   Supported types in this version:
*   1) OAD1
*
*   @title Orioneum Factory
*   @author Tore Stenbock
*/
contract OrioneumFactory is Ownable {

  // Orioneum Contracts (zero initializied)
  OrioneumWarehouse private warehouse = OrioneumWarehouse(0);

  // Holder for all availableOADTypeCodes for this deployed Factory
  mapping(uint8 => bool) availableOADTypeCodes;



  constructor(address _warehouseAddr) Ownable() public {
    warehouse = OrioneumWarehouse(_warehouseAddr);
    require(owner() == warehouse.owner());

    // Populate the mapping with available OADs from relevant OPDs
    availableOADTypeCodes[1] = true; // OAD1
  }



  /**
  *   Get BaseOAD information according to OPDs
  */
  function getBaseOADInfo(uint8 _oad_type) public view returns(string memory, string memory) {
    require(availableOADTypeCodes[_oad_type]);

    if (_oad_type == 1) { // OAD1
      return(
        "Item for sale",
        "Listing of a non-specialized item with a non-zero value and with basic owner information"
      );
    }

    // This should never happen
    return("", "");
  }
}
