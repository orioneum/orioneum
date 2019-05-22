pragma solidity ^0.5.7;

import "../OrioneumWarehouse.sol";



/**
*   BaseOAD style imported from the Warehouse contract
*
*   @title Orioneum Asset Definition One
*   @author Tore Stenbock
*/
contract OAD1 is BaseOAD {



  constructor(string memory _title, string memory _description) public {

    // Set the BaseOAD information
    title = _title;
    description = _description;
  }
}
