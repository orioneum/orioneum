pragma solidity 0.5.7;

import "./oads/OAD1.sol";
import "./OrioneumWarehouse.sol";
import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";



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



  constructor(address _warehouseAddr) public {
    OrioneumWarehouse warehouse = OrioneumWarehouse(_warehouseAddr);
    require(owner() == warehouse.owner());
  }



  /**
  *   Creates a smart contract representing OAD1 asset.
  *   Input: Title, Description
  */
  function createOAD1(string memory _title, string memory _description) public returns(address) {
    OAD1 _oad1 = new OAD1(_title, _description);
    return(address(_oad1));
  }
}
