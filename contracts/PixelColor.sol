// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library PixelColor {
    // 颜色范围：0-255
    uint8 constant MAX_COLOR_VALUE = 255;

    // 检查颜色值是否有效
    function isValidColor(uint8 color) public pure returns (bool) {
        return color <= MAX_COLOR_VALUE;
    }
}
