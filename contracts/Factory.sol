pragma solidity 0.5.8;

import "./BaseOAD.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   The Orioneum Factory. This contract provides functions for verification of
*   inputs and create functions for available OAD types.
*
*   @title Factory
*   @author Tore Stenbock
*/
contract Factory is Ownable {

  // All Factory events
  event Orioneum_CREATED_OAD      (address indexed oad_addr, address indexed owner_addr);

  // Maintain mapping of available assets
  mapping(uint => bool) private available_oad_types;
  uint public constant oad1_type = 1;
  uint public constant oad2_type = 2;
  uint private constant total_oad_types = 2;



  /**
  *   Factory constructor
  *
  *   @author Tore Stenbock
  */
  constructor() Ownable() public {
    // Initialize the available_oad_types mapping
    available_oad_types[oad1_type] = true;
    available_oad_types[oad2_type] = true;
  }

  /****************************************************************************/
  /***             Creating and registering OAD smart contracts            ****/
  /****************************************************************************/

  /**
  *   Create and register an OAD1 in one Tx
  *
  *   @author Tore Stenbock
  *   @param _oad_type The OAD type
  *   @param _bundleable Flag whether OAD is bundleable
  *   @param _digest Bytes32 representation of IPFS hash
  *   @param _hash_function Hash function for IPFS has
  *   @param _size Size of the IPFS hash minus header
  */
  function create(
    uint _oad_type,
    bool _bundleable,
    // Following is IPFS Multihash values
    bytes32 _digest,
    uint8 _hash_function,
    uint8 _size
  )
  public
  returns(address)
  {
    // Perform OAD1 value checks
    validateOADType(_oad_type);

    // Create the asset itself
    BaseOAD _oad = new BaseOAD(_oad_type, _bundleable, _digest, _hash_function, _size);
    _oad.transferOwnership(msg.sender);

    // Emit event and return the created address
    emit Orioneum_CREATED_OAD(address(_oad), _oad.owner());
    return(address(_oad));
  }



  /****************************************************************************/
  /****                Utils functions for OAD smart contracts             ****/
  /****************************************************************************/

  /**
  *   Validate a title text given for an OAD
  *
  *   @author Tore Stenbock
  *   @param _oad_type The OAD type to check
  */
  function validateOADType(uint _oad_type) internal view {
    require(available_oad_types[_oad_type], "Given OAD type invalid.");
  }

  /****************************************************************************/
  /****           External helper functions for Orioneum Dapps             ****/
  /****************************************************************************/

  /**
  *   Get all the available OAD type codes
  *
  *   @author Tore Stenbock
  *   @return An uint array of all available OAD type codes
  */
  function getAvailableOADTypeCodes() external pure returns(uint[] memory) {
    uint[] memory _available_oad_types = new uint[](total_oad_types);
    _available_oad_types[0] = oad1_type;
    _available_oad_types[1] = oad2_type;

    return(_available_oad_types);
  }

  /**
  *   Get the base title and description of the available assets
  *
  *   @author Tore Stenbock
  *   @param _oad_type Which OAD type to get base information of
  *   @return Two strings containing the base title and base description
  */
  function getOADTypeBaseInformation(uint _oad_type) external view returns(string memory, string memory) {
    require(available_oad_types[_oad_type], "Given OAD type invalid.");

    if (_oad_type == oad1_type) {
      return(
        "Item for sale",
        "A generic item with a non-zero sell value and with basic owner information."
      );
    }
    else if (_oad_type == oad2_type) {
      return(
        "Discount code",
        "A discount code with a zero sell value and with basic owner information."
      );
    }

    // This should never happen
    return("Error", "Something very wrong happened. This should not happen.");
  }
}
