// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PixelColor.sol";
import "./Epoch.sol";
import "./NFT.sol";

contract Canvas {
    
    PixelCanvasNFT public nftContract;

    uint public canvasWidth;
    uint public canvasHeight;
    uint public epoch;
    uint public epochLimit;
    address public lastInteractor;
    uint public width;
    uint public height;
    uint public maxEpoch;


    mapping(uint => mapping(uint => uint8)) public pixelColors;

    // 初始化画布
    constructor(uint _width, uint _height, uint _maxEpoch, address _nftContractAddress) {
        require(_width > 0, "Width must be greater than 0.");
        require(_height > 0, "Height must be greater than 0.");
        require(_maxEpoch > 0, "Max epoch must be greater than 0.");
    
        width = _width;
        height = _height;
        maxEpoch = _maxEpoch;
        nftContract = PixelCanvasNFT(_nftContractAddress);
    }


    // 设置像素颜色
    function setPixelColor(uint x, uint y, uint8 color) external {
        require(x < canvasWidth, "Invalid x coordinate");
        require(y < canvasHeight, "Invalid y coordinate");
        require(PixelColor.isValidColor(color), "Invalid color");

        pixelColors[x][y] = color;
        lastInteractor = msg.sender;

        // 检查时代是否达到上限
        if (Epoch.isEpochLimitReached(epoch, epochLimit)) {
            mintNFT();
        } else {
            Epoch.incrementEpoch(epoch);
        }
    }

    // 铸造NFT
    // 铸造NFT
function mintNFT() internal {
    // 生成元数据URI
    string memory tokenURI = generateTokenURI();

    // 铸造NFT并设置元数据URI
    uint256 tokenId = nftContract.createToken(lastInteractor, tokenURI);

    // 重置epoch
    epoch = 0;
}

function getCanvasData() external view returns (bytes memory) {
    // 将pixelColors转换为bytes格式
    bytes memory canvasData = new bytes(width * height);
    for (uint32 i = 0; i < width; i++) {
        for (uint32 j = 0; j < height; j++) {
            canvasData[i * width + j] = bytes1(pixelColors[i][j]);
        }
    }
    return canvasData;
}


    // 生成NFT元数据URI（这里仅为示例，您需要根据实际情况生成URI）
    function generateTokenURI() internal view returns (string memory) {
        return string(abi.encodePacked("https://api.example.com/nft/metadata/", uint2str(epoch)));
    }

        // 辅助函数:将uint转换为字符串
    function uint2str(uint _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

}
