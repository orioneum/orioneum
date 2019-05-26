pragma solidity 0.5.8;

import "../Warehouse.sol";



/**
*   BaseOAD style imported from the Warehouse contract
*
*   @title Orioneum Asset Definition One
*   @author Tore Stenbock
*/
contract OAD1 is BaseOAD {



  constructor(string memory _title, string memory _description, bool _bundleable) public {

    // Set the BaseOAD information
    oad_type = 1;
    bundleable = _bundleable;
    title = _title;
    description = _description;
  }
}
