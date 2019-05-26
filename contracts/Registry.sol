pragma solidity 0.5.8;

import "./Utils.sol";
import "./Warehouse.sol";
import "./oads/OAD1.sol";
import "./oads/OAD2.sol";


import "openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   The main Orioneum contract
*
*   @title Registry
*   @author Tore Stenbock
*/
contract Registry is Ownable {

  // All Registry events
  event Orioneum_CREATE_OAD1      (address indexed oad_addr, address indexed owner_addr);
  event Orioneum_CREATE_OAD2      (address indexed oad_addr, address indexed owner_addr);
  event Orioneum_REGISTER_NEW     (address indexed oad_addr);



  // Orioneum Contracts
  Utils private utils;
  Warehouse private warehouse;

  // Maintain mapping of available assets
  mapping(uint => bool) private available_oad_types;
  uint public constant oad1_type = 1;
  uint public constant oad2_type = 2;
  uint private constant total_oad_types = 2;



  /**
  *   Registry constructor
  *
  *   @author Tore Stenbock
  *   @param _utils_addr The address of the Utils contract
  *   @param _warehouse_addr The address of the Warehouse contract
  */
  constructor(address _utils_addr, address _warehouse_addr) Ownable() public {
    // Get a handle on the deployed Utils and Warehouse contracts
    utils = Utils(_utils_addr);
    warehouse = Warehouse(_warehouse_addr);
    require(owner() == utils.owner() && owner() == warehouse.owner(),
      "Registry owner must be same as Utils and Warehouse owner.");

    // Initialize the available_oad_types mapping
    available_oad_types[oad1_type] = true;
    available_oad_types[oad2_type] = true;
  }



  /****************************************************************************/
  /****             Registering pre-created OAD smart contracts            ****/
  /****************************************************************************/

  /**
  *   Register a previously created OAD1
  *
  *   @author Tore Stenbock
  *   @param _oad_addr The address of the OAD
  */
  function register(address _oad_addr) public {
    if(warehouse.add(_oad_addr)) {
      emit Orioneum_REGISTER_NEW(_oad_addr);
    }
  }



  /****************************************************************************/
  /****                       Warehouse interfacing                        ****/
  /****************************************************************************/


  /**
  *   Gets all OADs in the Warehouse matching _owner_addr
  *
  *   @author Tore Stenbock
  *   @param _owner_addr The address of the owner
  */
  function getByOwner(address _owner_addr) external view returns(address[] memory) {
    return(warehouse.get(_owner_addr));
  }

  /**
  *   Gets values from a given OAD1 address
  *
  *   @author Tore Stenbock
  *   @param _oad_addr The address of the OAD1
  */
  function getOAD1Values(address _oad_addr) external view returns(string memory, string memory, bool) {
    OAD1 _oad1 = OAD1(_oad_addr);
    return(_oad1.title(), _oad1.description(), _oad1.bundleable());
  }



  /****************************************************************************/
  /***             Creating and registering OAD smart contracts            ****/
  /****************************************************************************/

  /**
  *   Create and register an OAD1 in one Tx
  *
  *   @author Tore Stenbock
  *   @param _title The title text of the OAD
  *   @param _description The description text of the OAD
  *   @param _bundleable Flag whether this OAD can be bundled with other OADs
  */
  function createOAD1AndRegister(
    string memory _title,
    string memory _description,
    bool _bundleable
  )
  public
  {
    // Perform OAD1 value checks
    utils.validateOADTitle(_title);
    utils.validateOADDescription(_description);

    // Create the asset itself
    OAD1 _oad1 = new OAD1(_title, _description, _bundleable);
    _oad1.transferOwnership(msg.sender);
    emit Orioneum_CREATE_OAD1(address(_oad1), _oad1.owner());

    // Register the returned address
    register(address(_oad1));
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
    require(available_oad_types[_oad_type], "Invalid OAD type");

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
