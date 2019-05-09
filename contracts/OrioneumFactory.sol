pragma solidity 0.5.7;

import "./oads/OAD1.sol";
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

  /**
  *   Holder of all available OAD Types. Useful for getting base information of each OAD Type.
  */
  mapping(uint => bool) availableOADTypeCodes;
  uint private OAD1Type = 1;
  uint private OAD2Type = 2;



  constructor() public {
      // Populate the availableOADTypeCodes mapping
      availableOADTypeCodes[OAD1Type] = true;
      availableOADTypeCodes[OAD2Type] = false;
  }



  // BaseOAD information getter
  function getBaseOADInfo(uint _oad_type) public pure returns(string memory, string memory) {
    require(availableOADTypeCodes[_oad_type]);

    // Return the correct values
    if (_oad_type == OAD1Type) {
      return(OAD1.base_title, OAD1.base_description);
    }
    /* if (_oad_type == OAD2Type) {
      return(OAD2.base_title, OAD2.base_description);
    } */

    // This shouldn't happen
    return("", "");
  }



  function createAsset(uint _oad_type, string memory _title, string memory _description) public returns(address) {
    OAD1 _oad1 = new OAD1(_title, _description);

    return address(_oad1);
  }
}
