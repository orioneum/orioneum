pragma solidity 0.5.8;

import "./Factory.sol";
import "./Warehouse.sol";


import "openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   The main Orioneum contract
*
*   @title Registry
*   @author Tore Stenbock
*/
contract Registry is Ownable {

  // All Registry events
  event Orioneum_REGISTER_NEW       (address indexed oad_addr);
  event Orioneum_REGISTER_FAILED    (address indexed oad_addr);

  // Orioneum Contracts
  Factory private factory;
  Warehouse private warehouse;



  /**
  *   Registry constructor
  *
  *   @author Tore Stenbock
  *   @param _factory_addr The address of the Factory contract
  *   @param _warehouse_addr The address of the Warehouse contract
  */
  constructor(address _factory_addr, address _warehouse_addr) Ownable() public {
    // Get a handle on the deployed Factory and Warehouse contracts
    factory = Factory(_factory_addr);
    warehouse = Warehouse(_warehouse_addr);
    require(owner() == factory.owner() && owner() == warehouse.owner(),
      "Registry owner must be same as Factory and Warehouse owner.");
  }



  /****************************************************************************/
  /****             Registering pre-created OAD smart contracts            ****/
  /****************************************************************************/

  /**
  *   Register a previously created OAD
  *
  *   @author Tore Stenbock
  *   @param _oad_addr The address of the OAD
  */
  function register(address _oad_addr) public returns(bool) {
    if(!warehouse.add(_oad_addr)) {
      emit Orioneum_REGISTER_FAILED(_oad_addr);
      return(false);
    }

    emit Orioneum_REGISTER_NEW(_oad_addr);
    return(true);
  }

  /**
  *  Create and Register an OAD
  *   Useful function to bundle all transactions into one
  *
  *   @author Tore Stenbock
  *   @param _oad_type The OAD type
  *   @param _bundleable Flag whether OAD is bundleable
  *   @param _digest Bytes32 representation of IPFS hash
  *   @param _hash_function Hash function for IPFS has
  *   @param _size Size of the IPFS hash minus header
  */
  function createAndRegister(
    uint _oad_type,
    bool _bundleable,
    // Following is IPFS Multihash values
    bytes32 _digest,
    uint8 _hash_function,
    uint8 _size
  )
  public returns(bool)
  {
    address _oad_addr = factory.create(_oad_type, _bundleable, _digest, _hash_function, _size);
    return(register(_oad_addr));
  }



  /****************************************************************************/
  /****                   Query Warehouse and Registry                     ****/
  /****************************************************************************/

  /**
  *   Execute a query into the Registry and Warehouse to get all OADs
  *   of certain type and owner. See OPD documentation for more details.
  *
  *   @author Tore Stenbock
  *   @param _oad_type The OAD type
  *   @param _owner_addr The owner of the OADs
  *   @param _only_bundle Flag to return only bundles
  */
  function query(
    uint _oad_type,
    address _owner_addr,
    bool _only_bundle
  )
  public
  view
  returns(address[] memory)
  {
    address[] memory _oads_by_type = warehouse.getByType(_oad_type);
    address[] memory _oads_by_owner = warehouse.getByOwner(_owner_addr);

    return(_oads_by_type);
  }

  /**
  *   Execute a query into the Registry and Warehouse to get all OADs
  *   of certain type and all owners. See OPD documentation for more details.
  *
  *   @author Tore Stenbock
  *   @param _oad_type The OAD type
  *   @param _only_bundle Flag to return only bundles
  */
  function query(
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
