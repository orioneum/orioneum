pragma solidity 0.5.8;

import "./BaseOAD.sol";
import "./Warehouse.sol";


import "openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   The main Orioneum contract
*
*   @title Registry
*   @author Tore Stenbock
*/
contract Orioneum is Ownable {

  // All Registry events
  event Orioneum_REGISTER_NEW       (address indexed oad_addr);
  event Orioneum_REGISTER_FAILED    (address indexed oad_addr);

  // Orioneum Contracts
  Warehouse private warehouse;



  /**
  *   Orioneum constructor
  *
  *   @author Tore Stenbock
  *   @param _warehouse_addr The address of the Warehouse contract
  */
  constructor(address _warehouse_addr) Ownable() public {
    // Get a handle on the Orioneum contracts and validate ownerships
    warehouse = Warehouse(_warehouse_addr);
    require(owner() == warehouse.owner(), "Registry owner must be same as Factory and Warehouse owner.");
  }



  /****************************************************************************/
  /****             Registering pre-created OAD smart contracts            ****/
  /****************************************************************************/

  /**
  *   Create and Register an OAD
  *   The owner of the asset will be the sender of transaction
  *
  *   @author Tore Stenbock
  *   @param _oad_type The OAD type
  *   @param _bundleable Flag whether OAD is bundleable
  *   @param _ipfs_hash The IPFS hash of the OAD data
  */
  function register(
    uint _oad_type,
    bool _bundleable,
    string memory _ipfs_hash
  )
  public returns(bool)
  {
    // Create the asset and enforce proper owner
    BaseOAD _oad = new BaseOAD(_oad_type, _bundleable, _ipfs_hash);
    _oad.transferOwnership(msg.sender);

    // Add the asset to the warehouse
    if(!warehouse.add(_oad)) {
      emit Orioneum_REGISTER_FAILED(address(_oad));
      return(false);
    }

    emit Orioneum_REGISTER_NEW(address(_oad));
    return(true);
  }



  /****************************************************************************/
  /****                   Query Warehouse and Registry                     ****/
  /****************************************************************************/

  /**
  *   Execute a query into the Registry and Warehouse to get all OADs
  *   of certain type and owner. See OPD documentation for more details.
  *
  *   @author Tore Stenbock
  *   @param _owner_addr The owner of the OADs
  *   @param _only_bundle Flag to return only bundles
  */
  function queryByOwner(
    address _owner_addr,
    bool _only_bundle
  )
  public
  view
  returns(address[] memory)
  {
    address[] memory _oads_by_owner = warehouse.getByOwner(_owner_addr);
    return(_oads_by_owner);
  }

  /**
  *   Execute a query into the Registry and Warehouse to get all OADs
  *   of certain type and all owners. See OPD documentation for more details.
  *
  *   @author Tore Stenbock
  *   @param _oad_type The OAD type
  *   @param _only_bundle Flag to return only bundles
  */
  function queryByType(
    uint _oad_type,
    bool _only_bundle
  )
  public
  view
  returns(address[] memory)
  {
    address[] memory _oads_by_type = warehouse.getByType(_oad_type);
    return(_oads_by_type);
  }
}
