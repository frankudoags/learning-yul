// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

contract StorageSlots {
    uint256 x = 10;
    uint256 y = 20;
    uint256 z = 30;
    uint128 a = 1;
    uint128 b = 2;


    function getVarYul(uint256 slot) public view returns (uint256 value) {
        assembly {
            value := sload(slot)
        }
    }

    function setVarYul(uint256 slot, uint256 value) public {
        assembly {
            sstore(slot, value)
        }
    }


}