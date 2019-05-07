pragma solidity 0.5.7;

import "./OrioneumWarehouse.sol";
import "./OrioneumFactory.sol";
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
  constructor(address _warehouseAddr, address _factoryAddr) public {

    // Get a handle on the Factory and Warehouse contracts
    warehouse = OrioneumWarehouse(_warehouseAddr);
    factory = OrioneumFactory(_factoryAddr);

    // Strict requirement that owner of all Orioneum contracts are the same
    require(owner() == warehouse.owner() && owner() == factory.owner());
  }


  /**
  *   Register an asset with Orioneum. This will call appropriate factory function,
  *   followed with storing the contract in the Warehouse
  *
  *   @author Tore Stenbock
  */
  function registerAsset(uint _oad_type) pure external returns(string memory) {
    return("Hello world");
  }
}
