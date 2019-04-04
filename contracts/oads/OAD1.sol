pragma solidity 0.5.7;

import "../Warehouse.sol";

/**
*   OAD1: Final tradeable and unique assets
*   BaseOAD style imported from the Warehouse contract
*
*   @title Orioneum Asset Definition One
*   @author Tore Stenbock
*/
contract OAD1 is BaseOAD {

  /**
  *   Abstract function from BaseOAD
  */
  function setOADType(uint _oad_type) external {
    oad_type = _oad_type;
  }

  /**
  *   OAD oracle declarations
  */
}
