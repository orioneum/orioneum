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

  // Get access to all public values from available OADs
  OAD1 oad1;
  uint[] availableOADTypeCodes = [oad1.assetType()];



  function getAvailableOADTypeCodes() public view returns(uint[] memory) {
    // Simply return the list of available type codes
    return(availableOADTypeCodes);
  }

  function getBaseOADInfo() public view returns(bytes memory, bytes memory) {
    return(oad1.base_title(), oad1.base_description());
  }
}
