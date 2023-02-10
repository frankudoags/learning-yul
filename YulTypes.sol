// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;


contract YulTypes {
    function getNumber() external pure returns(uint256 x) {
        assembly {
            x := 42
        }
    }
    function getHex() external pure returns(uint256 x) {
        assembly {
            x := 0xa
        }
    }

    function demoString() external pure returns (string memory) {
        bytes32 x = '';
        assembly {
            x := "Hello World"
        }
        return string(abi.encode(x));
    }
        
}