pragma solidity 0.5.7;

import "./utils/Codes.sol";
import "./oads/BaseOAD.sol";

/**
*   The base storage for the Orioneum Asset Registry.
*   The registry will reference to this storage to determine if an asset has been
*   previously been deployed.
*   This class is useful as it is OAD agnostic as long as the asset to be stored is
*   of BaseOAD type.
*
*   @title Orioneum Asset Warehouse
*   @author Tore Stenbock
*/
contract Warehouse {

  // All Orioneum Warehouse events declarations
  event AddedAssetEvent(address indexed oad);

  // Create references to Codes
  ReturnCodes private Codes;
  OADTypes private oadTypes;

  // Storage struct and array
  struct AssetStorage {
    address oad_addr;
    uint oad_type;
    BaseOAD base_oad;
  }
  AssetStorage[] private records;

  /**
  *   Add OADs and record BaseOAD info into the storage
  */
  function addAsset(address _oad_addr) public returns(uint) {

    // Convert to BaseOAD contract
    // TODO: What if it is not a OAD type?
    BaseOAD _base_oad = BaseOAD(_oad_addr);

    // Require the OAD Type to be other than Unknown
    require(_base_oad.oadType() != oadTypes.Unknown());

    // Push to the warehouse storage
    records.push(AssetStorage({
      oad_addr: _oad_addr,
      oad_type: _base_oad.oadType(),
      base_oad: _base_oad
    }));

    // Emit event and return SUCCESS
    emit AddedAssetEvent(_oad_addr);
    return Codes.SUCCESS();
  }

  /**
  *   Get the total number of assets in storage
  */
  function totalAssets() public view returns(uint) {
    return records.length;
  }
}
