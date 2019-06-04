// https://github.com/saurfang/ipfs-multihash-on-solidity

import bs58 from 'bs58';



/**
 * Partition multihash string into object representing multihash
 *
 * @param {string} multihash A base58 encoded multihash string
 * @returns {Multihash}
 */
export function getBreakdownFromMultihash(multihash) {
  const decoded = bs58.decode(multihash);

  return {
    digest: `0x${decoded.slice(2).toString('hex')}`,
    hash_function: decoded[0],
    size: decoded[1],
  };
}

/**
 * Encode a multihash structure into base58 encoded multihash string
 *
 * @param digest
 * @param hash_function
 * @param size
 * @returns {(string|null)} base58 encoded multihash string
 */
export function getMultihashFromBreakdown(digest, hash_function, size) {
  if (size === 0) return null;

  // cut off leading "0x"
  const hashBytes = Buffer.from(digest.slice(2), 'hex');

  // prepend hashFunction and digest size
  const multihashBytes = new (hashBytes.constructor)(2 + hashBytes.length);
  multihashBytes[0] = hash_function;
  multihashBytes[1] = size;
  multihashBytes.set(hashBytes, 2);

  return bs58.encode(multihashBytes);
}
