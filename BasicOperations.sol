// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

contract BasicOperations {
    function isPrime(uint256 x) public pure returns (bool p) {
        p = true;
        assembly {
            let halfX := add(div(x, 2), 1)
            for {
                let i := 2
            } lt(i, halfX) {
                i := add(i, 1)
            } {
                if iszero(mod(x, i)) {
                    p := 0
                    break
                }
            }
        }
    }
}
