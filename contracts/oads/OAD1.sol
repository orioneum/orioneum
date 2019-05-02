pragma solidity 0.5.7;

import "../OrioneumWarehouse.sol";



/**
*   BaseOAD style imported from the Warehouse contract
*
*   @title Orioneum Asset Definition One
*   @author Tore Stenbock
*/
contract OAD1 is BaseOAD {

  string public title = "";
  string public description = "";



  constructor(string memory _title, string memory _description) public {
    title = _title;
    description = _description;
  }



  function getAssetDescription() view public returns(uint, string memory, string memory) {
    return(oad_type, title, description);
  }
}
