pragma solidity 0.5.8;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   Base contract representing all root components of all OADs.
*   Some functions are abstract and therefore requires the OAD class to implement
*   that functionality.
*
*   @title BaseOAD
*   @author Tore Stenbock
*/
contract BaseOAD is Ownable {
  uint public oad_type = 0; // Zero value means not initialized
  uint public creation_time = now; // (uint): current block timestamp (alias for block.timestamp)
  bool public bundleable = false;
  string public title = "";
  string public description = "";
}




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

  /**
  *   All events related to the Orioneum Warehouse
  */
  event AddedAllowedSender       (address indexed sender);
  event RemovedAllowedSender     (address indexed sender);

  event Orioneum_ADD_SUCCESS     (address indexed oad_addr, address indexed owner_addr);
  event Orioneum_ADD_EXISTS      (address indexed oad_addr);



  // Warehouse storage
  mapping(address => bool) private oad_addr_exist;
  mapping(address => address[]) private oad_addr_by_owner;



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
    emit AddedAllowedSender(_sender);
  }
  function removeAllowedSender(address _sender) external onlyOwner {
    allowedSenders[_sender] = false;
    emit RemovedAllowedSender(_sender);
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
    require(_base_oad.oad_type() > 0, "The given OAD not valid.");

    // Check that the asset has not been added previously
    if(exists(_oad_addr)) {
      emit Orioneum_ADD_EXISTS(_oad_addr);
      return(false);
    }

    // Create and store an OAD structure
    oad_addr_exist[_oad_addr] = true;
    oad_addr_by_owner[_base_oad.owner()].push(_oad_addr);

    // Emit event
    emit Orioneum_ADD_SUCCESS(_oad_addr, _base_oad.owner());
    return(true);
  }

  /**
  *   Gets all OADs in the Warehouse matching _owner_addr
  *
  *   @author Tore Stenbock
  *   @param _owner_addr The address of the owner
  *   @return An array of addresses with all OAD addresses owned by _owner_addr
  */
  function get(address _owner_addr) external view onlyOrioneum returns(address[] memory) {
    return(oad_addr_by_owner[_owner_addr]);
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
