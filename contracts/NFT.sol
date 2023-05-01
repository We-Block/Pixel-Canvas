// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";        
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";  
import "./CanvasContract.sol";

contract PixelCanvasNFT is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    address public canvasAddress;

    mapping(uint256 => bytes) public canvasByTokenId;

    constructor(address _canvasAddress) ERC721("PixelCanvasNFT", "PCN") {
        canvasAddress = _canvasAddress;
    }

    // 覆盖 _beforeTokenTransfer 方法
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal  { 
        super._beforeTokenTransfer(from, to, tokenId, 0);
    }



    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
    return ERC721URIStorage.tokenURI(tokenId);
    }

    // 覆盖 _burn 方法
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    // 铸造NFT
    function createToken(address to, string memory _tokenURI) public returns (uint256) {
        require(msg.sender == canvasAddress, "Only the Canvas contract can mint tokens.");
        uint256 newTokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, tokenURI(newTokenId)); 

        // 添加此行以从 Canvas 合约获取画布数据
        Canvas canvasInstance = Canvas(canvasAddress);
        bytes memory canvasData = canvasInstance.getCanvasData();


        canvasByTokenId[newTokenId] = canvasData;
        return newTokenId;
    }


    // 设置NFT元数据URI
    function setTokenURI(uint256 tokenId, string memory _tokenURI) external {
        _setTokenURI(tokenId, tokenURI(tokenId)); 
    }


    // 获取画布数据
    function getCanvasData(uint256 tokenId) external view returns (uint8[][] memory) {
        bytes storage ref = canvasByTokenId[tokenId];
        uint8[][] memory canvasData = new uint8[][](ref.length);
        // Convert ref to canvasData and return canvasData
} 

}
