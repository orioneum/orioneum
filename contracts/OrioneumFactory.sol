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



  function getAvailableOADTypeCodes() public view returns(uint[] memory) {
    // Simply create and return a list of available type codes
    uint totalAvailableOADTypeCodes = 1;
    uint[] memory availableOADTypeCodes = new uint[](totalAvailableOADTypeCodes); 
    availableOADTypeCodes[0] = oad1.assetType();

    return(availableOADTypeCodes);
  }

  function getBaseOADInfo() public view returns(bytes memory, bytes memory) {
    return(oad1.base_title(), oad1.base_description());
  }
}
