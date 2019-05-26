pragma solidity 0.5.8;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   The Orioneum Utils. This contract provides functions for verification of
*   inputs and managing available OAD types.
*
*   @title Utils
*   @author Tore Stenbock
*/
contract Utils is Ownable {

  /****************************************************************************/
  /****                Utils functions for OAD smart contracts             ****/
  /****************************************************************************/

  /**
  *   Validate a title text given for an OAD
  *
  *   @author Tore Stenbock
  *   @param _title The title text of the OAD
  */
  function validateOADTitle(string memory _title) public pure {
    require(bytes(_title).length >= 8 && bytes(_title).length <= 32, // According to OPDs
      "Title not within range of [8,32] characters");
  }

  /**
  *   Validate a description text given for an OAD
  *
  *   @author Tore Stenbock
  *   @param _description The description text of the OAD
  */
  function validateOADDescription(string memory _description) public pure {
    require(bytes(_description).length >= 32 && bytes(_description).length <= 256, // According to OPDs
      "Description not within range of [32, 256] characters");
  }
}
