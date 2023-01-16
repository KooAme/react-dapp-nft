// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MintDrawToken is ERC721Enumerable{
  constructor() ERC721("abocado", "ABO"){}

  mapping(uint256 => uint256) public drawTypes;

  function drawToken() public {
    uint256 drawTokenId = totalSupply() + 1;

    uint256 drawType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, drawTokenId))) % 5 + 1;

    drawTypes[drawTokenId] = drawType;

    _mint(msg.sender, drawTokenId); //drawTokenId nft의 유일한 값
  }
}