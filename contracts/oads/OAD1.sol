pragma solidity 0.5.7;

import "../OrioneumWarehouse.sol";



/**
*   BaseOAD style imported from the Warehouse contract
*
*   @title Orioneum Asset Definition One
*   @author Tore Stenbock
*/
contract OAD1 is BaseOAD {

  string public base_title = "Item for sale";
  string public base_description = "Listing of a non-specialized item with a non-zero value and with basic owner information";

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
