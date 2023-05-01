// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Epoch {
    // 增加epoch值
    function incrementEpoch(uint _currentEpoch) public pure returns (uint) {
        return _currentEpoch + 1;
    }

    // 检查epoch是否达到设定上限
    function isEpochLimitReached(uint _currentEpoch, uint _epochLimit) public pure returns (bool) {
        return _currentEpoch >= _epochLimit;
    }
}
