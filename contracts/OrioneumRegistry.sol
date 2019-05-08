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
  OrioneumWarehouse private warehouse = OrioneumWarehouse(0);
  OrioneumFactory private factory = OrioneumFactory(0);

  // Require the Factory and Warehouse addresses on contract creation
  constructor(address _warehouseAddr, address _factoryAddr) public {

    // Get a handle on the Factory and Warehouse contracts
    warehouse = OrioneumWarehouse(_warehouseAddr);
    factory = OrioneumFactory(_factoryAddr);

    // Strict requirement that owner of all Orioneum contracts are the same
    require(owner() == warehouse.owner() && owner() == factory.owner());
  }


  /**
  *   Register an asset with Orioneum that has already been created.
  *   Forward the address to the Warehouse for checks and storage.
  *
  *   @author Tore Stenbock
  */
  function registerAsset(address _oad_addr) public returns(bool) {
    warehouse.addAsset(_oad_addr);

    return true;
  }

  function registerAsset(uint _oad_type, string memory _title, string memory _description) public returns(address) {
    address _oad_addr = factory.createAsset(_oad_type, _title, _description);
    registerAsset(_oad_addr);

    return _oad_addr;
  }


}
