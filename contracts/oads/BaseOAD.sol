pragma solidity 0.5.7;

import "../utils/Codes.sol";
import "../../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
*   Base cotnract representing all root components of all OADs.
*   Some functions are abstract and therefore requires the OAD class to implement
*   that functionality.
*   @title Orioneum Base Asset Contract
*   @author Tore Stenbock
*/
contract BaseOAD is Ownable {

  // Get a reference to the OAD Type codes
  OADTypes private oadTypes;

  // In addition to functions and modifiers from Ownable.sol, this is the
  // base information required for all OAD assets
  uint public creationTime = now;
  uint public oadType = oadTypes.Unknown();
}
