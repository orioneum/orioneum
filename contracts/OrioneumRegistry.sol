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
  OrioneumFactory private factory = OrioneumFactory(0);
  OrioneumWarehouse private warehouse = OrioneumWarehouse(0);

  // Require the Factory and Warehouse addresses on contract creation
  constructor(address _factoryAddr, address _warehouseAddr) public {

    // Get a handle on the Factory and Warehouse contracts
    factory = OrioneumFactory(_factoryAddr);
    warehouse = OrioneumWarehouse(_warehouseAddr);

    // Strict requirement that owner of all Orioneum contracts are the same
    require(owner() == factory.owner() && owner() == warehouse.owner());
  }
}
