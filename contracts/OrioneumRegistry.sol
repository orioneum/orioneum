pragma solidity 0.5.7;

import "./OrioneumFactory.sol";
import "./OrioneumWarehouse.sol";
import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   The main Orioneum Asset Registry.
*
*   @title Registry
*   @author Tore Stenbock
*/
contract OrioneumRegistry is Ownable {

  // Orioneum Contracts (zero initializied)
  OrioneumWarehouse private warehouse = OrioneumWarehouse(0);



  constructor(address _warehouseAddr) public {
    warehouse = OrioneumWarehouse(_warehouseAddr);
    require(owner() == warehouse.owner());
  }



  
}
