// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

contract BoxAssembly {
    uint256 private _value;

    function retrieve() public view returns (uint256) {
        assembly {
            // load value at slot 0 of storage
            let v := sload(0)
            //because v is currently in call stack and return opcode
            //works with memory only, move `v` to memory
            /**
             * mstore
                It also takes two inputs:

                offset: which is location (in memory array) where the value should be stored
                value: which is bytes to store (which is v for us).
            */
            //store v at free memory 0x80

            mstore(0x80, v)

            //return takes two inputs:
            /**
             * offset:  which is the location of where the value starts from in memory
             * size: which is the number of bytes starting from offset.
             */

            //now return first 32 bytes of data at memory address `0x80`
            return(0x80, 32)
        }
    }

    function store(uint256 newValue) public {
        assembly {
            //store newValue at slot 0 of storage
            sstore(0, newValue)

            //store newValue in memory at free mem pointer 0x80
            //because we woud need it to log the event
            mstore(0x80, newValue)
            /**
             * To emit the event (NewValue) with new value data, we used log1 opcode.
             *  First two parameters to it are offset in memory and size of the data like other opcodes.
             * Now, you might be wondering what is that third argument we passed in to log1.
             *  It is topic - sort of a label for event, like the name - NewValue.
             *  The passed in argument is nothing but the hash of the event signature:
             *
             * bytes32(keccak256("NewValue(uint256)")) = 0xac3e966f295f2d5312f973dc6d42f30a6dc1c1f76ab8ee91cc8ca5dad1fa60fd
             */
            log1(
                0x80,
                0x20,
                0xac3e966f295f2d5312f973dc6d42f30a6dc1c1f76ab8ee91cc8ca5dad1fa60fd
            )
        }
    }
}

//without comments
contract BoxAssembly2 {
    uint256 private _value;

    function retrieve() public view returns (uint256) {
        assembly {
            let v := sload(0)
            mstore(0x80, v)
            return(0x80, 32)
        }
    }

    function store(uint256 newValue) public {
        assembly {
            sstore(0, newValue)
            mstore(0x80, newValue)
            log1(
                0x80,
                0x20,
                0xac3e966f295f2d5312f973dc6d42f30a6dc1c1f76ab8ee91cc8ca5dad1fa60fd
            )
        }
    }
}
