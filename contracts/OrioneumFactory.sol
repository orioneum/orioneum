pragma solidity 0.5.7;

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
  mapping(uint => bool) availableOADTypeCodes;



  constructor(address _warehouseAddr) public {
    warehouse = OrioneumWarehouse(_warehouseAddr);
    require(owner() == warehouse.owner());

    availableOADTypeCodes[1] = true; // OAD1
  }



  /**
  *   Get BaseOAD information according to OPDs
  */
  function getBaseOADInfo(uint _oad_type) public view returns(string memory, string memory) {
    require(availableOADTypeCodes[_oad_type]);

    return("Item for sale1", "Item for sale2");
  }
}
