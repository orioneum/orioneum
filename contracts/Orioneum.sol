pragma solidity ^0.5.0;

contract Orioneum {

  struct Asset {
    address owner;
    address oad_addr;
  }
  Asset[] private assets;

  function addAssetListing(address _oad_addr) public {
    // ...
  }

  function totalAssets() public view returns (uint) {
    return assets.length;
  }
}
