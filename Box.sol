// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

contract Box {
    uint256 private _value;

    event NewValue(uint256 newValue);

    function store(uint256 newValue) public{
        _value = newValue;
        emit NewValue(newValue);
    }

    function retrieve() public view returns(uint256){
        return _value;
    }
}