pragma solidity ^0.5.7;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   Base contract representing all root components of all OADs.
*   Some functions are abstract and therefore requires the OAD class to implement
*   that functionality.
*
*   @title Orioneum Base Asset Contract
*   @author Tore Stenbock
*/
contract BaseOAD is Ownable {
  uint8 public oad_type = 0; // Zero value means not initialized
  uint256 public creation_time = now; // (uint): current block timestamp (alias for block.timestamp)
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

  struct AssetStorage {
    address oad_addr;
    address oad_owner;
    BaseOAD base_oad;
  }
  mapping(address => AssetStorage) private oads;



  function addAsset(address _oad_addr) onlyOwner public {
    require(oads[_oad_addr].oad_owner != address(0x0)); // Non-existing entries default to zero

    BaseOAD _base_oad = BaseOAD(_oad_addr);
    require(_base_oad.oad_type() > 0);

    AssetStorage memory _asset = AssetStorage(
      _oad_addr,
      _base_oad.owner(),
      _base_oad
    );

    oads[_oad_addr] = _asset;
  }
}
