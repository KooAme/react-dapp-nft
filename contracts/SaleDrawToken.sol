// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "MintDrawToken.sol";

contract SaleDrawToken {
    MintDrawToken public mintDrawTokenAddress;

    constructor (address _mintDrawTokenAddress) {
        mintDrawTokenAddress = MintDrawToken(_mintDrawTokenAddress);
    }

    mapping(uint256 => uint256) public drawTokenPrices;

    uint256[] public onSaleDrawTokenArray;

    //판매등록 함수
    function setForSaleDrawToken(uint256 _drawTokenId, uint256 _price) public {
        address drawTokenOwner = mintDrawTokenAddress.ownerOf(_drawTokenId);

        require(drawTokenOwner == msg.sender, "Caller is not Draw token owner");
        require(_price > 0, "Price is zero or lower.");
        require(drawTokenPrices[_drawTokenId] == 0, "This draw token is already on sale.");
        require(mintDrawTokenAddress.isApprovedForAll(drawTokenOwner, address(this)),"Draw token owner did not approve token.");
        
        drawTokenPrices[_drawTokenId] = _price;

        onSaleDrawTokenArray.push(_drawTokenId);
    }

    //구매함수
    function purchaseDrawToken(uint256 _drawTokenId) public payable {
        uint256 price = drawTokenPrices[_drawTokenId];
        address drawTokenOwner = mintDrawTokenAddress.ownerOf(_drawTokenId);

        require(price > 0, "Draw Token not sale.");
        require(price <= msg.value, "caller sent lower than price.");
        require(drawTokenOwner != msg.sender, "Caller is draw token owner.");

        payable(drawTokenOwner).transfer(msg.value); 
        mintDrawTokenAddress.safeTransferFrom(drawTokenOwner, msg.sender, _drawTokenId);

        drawTokenPrices[_drawTokenId] = 0;

        for(uint256 i = 0; i < onSaleDrawTokenArray.length; i++){
            if(drawTokenPrices[onSaleDrawTokenArray[i]] == 0){
                onSaleDrawTokenArray[i] = onSaleDrawTokenArray[onSaleDrawTokenArray.length - 1];
                onSaleDrawTokenArray.pop();
            }
        }
    }

    function getOnSaleDrawTokenArrayLength() view public returns(uint256){
        return onSaleDrawTokenArray.length;
    }
}