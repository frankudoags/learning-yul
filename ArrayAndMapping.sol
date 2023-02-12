// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

contract StorageComplex {
    uint256[3] fixedArray;
    uint256[] bigArray;
    uint8[] smallArray;

    mapping(uint256 => uint256) public myMapping;
    mapping(uint256 => mapping(uint256 => uint256)) public nestedMapping;

    mapping(address => uint256[]) public addresstoList;

    constructor() {
        fixedArray = [99, 999, 9999];
        bigArray = [10, 20, 30];
        smallArray = [1, 2, 3];

        myMapping[10] = 5;
        myMapping[11] = 6;
        nestedMapping[2][4] = 7;

        addresstoList[msg.sender] = [42, 1337, 777];
    }

    function fixedArrayView(uint256 index) public view returns (uint256 ret) {
        assembly {
            //load the value at index in fixedArray
            ret := sload(add(fixedArray.slot, index))
        }
    }

    function bigArrayLength() public view returns (uint256 ret) {
        assembly {
            //load the value at index in bigArray
            ret := sload(bigArray.slot)
        }
    }

    function getElementInBigArray(
        uint256 index
    ) external view returns (uint256 ret) {
        /**
         *  declare a variable to hold the dynamic array's slot
         * we need to find the hash of the slot because
         * solidity stores only the array length at the slot location
         * It stores the actual values starting from the hash of the slot
         * i.e the keccak256 hash of the slot(keccak256(slot))
         * to get a value, we get the hash of the slot,
         * add the index of the element to the hash of the slot
         * and sload the resulting value
         */

        uint256 slot;
        assembly {
            slot := bigArray.slot
        }
        bytes32 location = keccak256(abi.encode(slot));

        assembly {
            ret := sload(add(location, index))
        }
    }

    function smallArrayLength() public view returns (uint256 ret) {
        assembly {
            //load the value at index in smallArray
            ret := sload(smallArray.slot)
        }
    }

    function getElementInSmallArray(
        uint256 index
    ) external view returns (bytes32 ret) {
        uint256 slot;
        assembly {
            slot := smallArray.slot
        }
        bytes32 location = keccak256(abi.encode(slot));

        assembly {
            ret := sload(add(location, index))
        }
    }

    function getMapping(uint256 key) external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := myMapping.slot
        }
        bytes32 location = keccak256(abi.encode(key, uint256(slot)));

        assembly {
            ret := sload(location)
        }
    }
    function getNestedMapping() external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := nestedMapping.slot
        }
        bytes32 location = keccak256(abi.encode(uint256(4), keccak256(abi.encode(uint256(2), uint256(slot)))));

        assembly {
            ret := sload(location)
        }
    }
}
