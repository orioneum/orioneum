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

  // Following is IPFS Multihash values
  struct IPFSMultiHash {
    bytes32 digest;
    uint8 hash_function;
    uint8 size;
  }

  // Mandatory values for all BaseOADs
  uint public oad_type = 0;
  uint public creation_time = now;
  bool public bundleable = false;
  IPFSMultiHash private ipfs;



  constructor(
    uint _oad_type,
    bool _bundleable,
    bytes32 _digest,
    uint8 _hash_function,
    uint8 _size
  )
  Ownable()
  public
  {
    oad_type = _oad_type;
    bundleable = _bundleable;
    ipfs = IPFSMultiHash(_digest, _hash_function, _size);
  }



  function getIPFSMultihash() public view returns(bytes32, uint8, uint8) {
    return(ipfs.digest, ipfs.hash_function, ipfs.size);
  }
}
