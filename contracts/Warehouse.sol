pragma solidity 0.5.7;

import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
*   Base cotnract representing all root components of all OADs.
*   Some functions are abstract and therefore requires the OAD class to implement
*   that functionality.
*   @title Orioneum Base Asset Contract
*   @author Tore Stenbock
*/
contract BaseOAD is Ownable {

  // In addition to functions and modifiers from Ownable.sol, this is the
  // base information required for all OAD assets
  uint public creation_time = now;
  uint public oad_type = 0; // Zero value means not initialized

  // Abstract function all parents must implement
  function setOADType(uint _oad_type) external;
}



/**
*   The base storage for the Orioneum Marketplace.
*   The Orioneum Registry and Factory will reference to this storage when
*   an asset is to be deployed and accessed.
*   This class is useful as it is OAD agnostic as long as the asset is
*   of BaseOAD type.
*
*   @title Orioneum Asset Warehouse
*   @author Tore Stenbock
*/
contract Warehouse {

  // Storage struct and address mapping
  struct AssetStorage {
    address oad_addr;
    address oad_owner;
    uint oad_type;
    BaseOAD base_oad;
  }
  mapping(address => AssetStorage) private oads;  // (OAD Address => AssetStorage struct)

  /**
  *   Add OADs and record BaseOAD info and owner info into the storage
  */
  function addAsset(address _oad_addr) external {

    // Check if OAD already is registered
    require(oads[_oad_addr].oad_owner != address(0x0)); // Non-existing entries default to zero

    // Convert to BaseOAD contract and enforce requirements
    BaseOAD _base_oad = BaseOAD(_oad_addr);
    require(_base_oad.oad_type() > 0);

    // Package the asset before storing
    AssetStorage memory _asset = AssetStorage(
      _oad_addr,
      _base_oad.owner(),
      _base_oad.oad_type(),
      _base_oad
    );

    // Store the asset
    oads[_oad_addr] = _asset;
  }

  /**
  *   Get an OAD stored based on priviledges of the sender
  */
  function getAssets() external view returns(address[] memory) {
    address[] memory _oads;
    return _oads;
  }
}
