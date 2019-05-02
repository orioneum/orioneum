pragma solidity 0.5.7;

import "../OrioneumWarehouse.sol";



/**
*   BaseOAD style imported from the Factory contract
*
*   @title Orioneum Asset Definition One
*   @author Tore Stenbock
*/
contract OAD1 is BaseOAD {

  // OAD1 digital twin information
  string public title = "";
  string public description = "";

  // Create the digital twin of OAD1 type with all required information
  constructor(string memory _title, string memory _description) public {

    // Initialize digital twin specific values
    title = _title;
    description = _description;
  }

  // Return all related fixed information about this type of asset including human-readable titles, and so on.
  function getAssetDescription() view public returns(uint, string memory, string memory) {
    return(oad_type, title, description);
  }
}
