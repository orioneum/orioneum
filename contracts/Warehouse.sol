pragma solidity 0.5.8;

import "./BaseOAD.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   The base storage for the Orioneum Marketplace.
*   The Orioneum Registry will reference to this storage when
*   an asset is to be deployed and accessed.
*   This class is useful as it is OAD agnostic as long as the asset is
*   of BaseOAD type.
*
*   @title Warehouse
*   @author Tore Stenbock
*/
contract Warehouse is Ownable {

  // Events for standalone Warehouse actions
  event Warehouse_AddedAllowedSender       (address indexed sender);
  event Warehouse_RemovedAllowedSender     (address indexed sender);
  // Warehouse events
  event Orioneum_ADD_SUCCESS               (address indexed oad_addr);
  event Orioneum_ADD_EXISTS                (address indexed oad_addr);



  // Warehouse storage
  mapping(address => bool) private oad_addr_exist;
  mapping(uint => address[]) private oads_addr_by_type;
  mapping(address => address[]) private oads_addr_by_owner;



  /****************************************************************************/
  /****                         Access Control Logic                       ****/
  /****************************************************************************/

  mapping(address => bool) private allowedSenders;
  modifier onlyOrioneum() {
    require(allowedSenders[msg.sender], "Current sender not allowed");
    _;
  }
  function addAllowedSender(address _sender) external onlyOwner {
    allowedSenders[_sender] = true;
    emit Warehouse_AddedAllowedSender(_sender);
  }
  function removeAllowedSender(address _sender) external onlyOwner {
    allowedSenders[_sender] = false;
    emit Warehouse_RemovedAllowedSender(_sender);
  }



  /****************************************************************************/
  /****                  Add Get Update Remove functions                   ****/
  /****************************************************************************/

  /**
  *   Add an OAD into the warehouse given its address
  *   The warehouse will assume the OAD smart contract owner is the main owner
  *
  *   @author Tore Stenbock
  *   @param _oad_addr The smart contract address of the OAD to be added
  */
  function add(address _oad_addr) external onlyOrioneum returns(bool) {

    // Do checks that will trigger reverts if happen
    BaseOAD _base_oad = BaseOAD(_oad_addr);

    // Check that the asset has not been added previously
    if(exists(_oad_addr)) {
      emit Orioneum_ADD_EXISTS(_oad_addr);
      return(false);
    }

    // Create and store an OAD structure
    oad_addr_exist[_oad_addr] = true;
    oads_addr_by_owner[_base_oad.owner()].push(_oad_addr);
    oads_addr_by_type[_base_oad.oad_type()].push(_oad_addr);

    // Emit event
    emit Orioneum_ADD_SUCCESS(_oad_addr);
    return(true);
  }

  /**
  *   Gets all OADs in the Warehouse matching _owner_addr
  *
  *   @author Tore Stenbock
  *   @param _owner_addr The address of the owner
  *   @return An array of addresses with all OAD addresses owned by _owner_addr
  */
  function getByOwner(address _owner_addr) external view onlyOrioneum returns(address[] memory) {
    return(oads_addr_by_owner[_owner_addr]);
  }

  /**
  *   Gets all OADs in the Warehouse matching _oad_type
  *
  *   @author Tore Stenbock
  *   @param _oad_type The oad tpye
  *   @return An array of addresses with all OAD addresses of type
  */
  function getByType(uint _oad_type) external view onlyOrioneum returns(address[] memory) {
    return(oads_addr_by_type[_oad_type]);
  }



  /****************************************************************************/
  /****                     Internal helper functions                      ****/
  /****************************************************************************/

  /**
  *   Check if an OAD has already been added
  *
  *   @author Tore Stenbock
  *   @param _oad_addr The OAD address to be checked
  *   @return True or False if _oad_addr has already been deployed
  */
  function exists(address _oad_addr) internal view returns(bool) {
    return(oad_addr_exist[_oad_addr]);
  }
}
