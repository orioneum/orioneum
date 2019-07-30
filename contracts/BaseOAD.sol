pragma solidity 0.5.8;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";



/**
*   Base contract representing root components of all OADs.
*   The on-chain information is Owner, Type, Bundleable, and IPFS hash.
*
*   @title BaseOAD
*   @author Tore Stenbock
*/
contract BaseOAD is Ownable {
  // Mandatory values for all BaseOADs
  uint public oad_type = 0;
  uint public creation_time = now;
  bool public bundleable = false;
  string public ipfs_hash;



  constructor(
    uint _oad_type,
    bool _bundleable,
    string memory _ipfs_hash
  )
  Ownable()
  public
  {
    oad_type = _oad_type;
    bundleable = _bundleable;
    ipfs_hash = _ipfs_hash;
  }
}
