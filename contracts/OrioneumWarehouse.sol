pragma solidity 0.5.7;

import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   Base contract representing all root components of all OADs.
*   Some functions are abstract and therefore requires the OAD class to implement
*   that functionality.
*
*   @title Orioneum Base Asset Contract
*   @author Tore Stenbock
*/
contract BaseOAD is Ownable {

  // Base information required for all OAD assets
  uint public oad_type = 0; // Zero value means not initialized
  uint public creation_time = now;
}


/**
*   The base storage for the Orioneum Marketplace.
*   The Orioneum Registry will reference to this storage when
*   an asset is to be deployed and accessed.
*   This class is useful as it is OAD agnostic as long as the asset is
*   of BaseOAD type.
*
*   @title Orioneum Asset Warehouse
*   @author Tore Stenbock
*/
contract OrioneumWarehouse is Ownable {

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
  function addAsset(address _oad_addr) onlyOwner external {

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
}
