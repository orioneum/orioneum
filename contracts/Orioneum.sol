pragma solidity 0.5.7;

import "./Warehouse.sol";

/**
*   The main Orioneum Asset Registry.
*
*   @title Registry
*   @author Tore Stenbock
*/
contract Registry {

  // All Orioneum Warehouse events declarations
  event AddedAssetEvent(address indexed oad);

  // Get a handle to the deployed Warehouse contract
  Warehouse private warehouse = Warehouse(0x644Ad1577Ac7dA3C54dd7c68bcf6a6CF5eeEAe09);

  /**
  *   Register an OAD into the warehouse
  */
  function registerAsset(address _oad_addr) public {
    warehouse.addAsset(_oad_addr);

    // Emit event and return success
    emit AddedAssetEvent(_oad_addr);
  }
}
