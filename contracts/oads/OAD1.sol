pragma solidity 0.5.7;

import "../OrioneumWarehouse.sol";



/**
*   BaseOAD style imported from the Warehouse contract
*
*   @title Orioneum Asset Definition One
*   @author Tore Stenbock
*/
contract OAD1 is BaseOAD {

  uint public assetType = 1;

  bytes public base_title = "Item for sale";
  bytes public base_description = "Listing of a non-specialized item with a non-zero value and with basic owner information";

  bytes public title = "";
  bytes public description = "";



  constructor(bytes memory _title, bytes memory _description) public {
    title = _title;
    description = _description;
  }

}
