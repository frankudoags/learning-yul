// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

contract StoragePart1 {
    uint128 public C = 4; //32 digits -- 16 bytes
    uint96 public D = 5; //24 digits -- 12 bytes
    uint16 public E = 6; //4 digits  -- 2 bytes
    uint8 public F = 7; //4 digits  -- 2 bytes

    function readBySlot(uint256 slot) public view returns (bytes32 value) {
        assembly {
            //0x 0007 0006 000000000000000000000005 00000000000000000000000000000004
            value := sload(slot)
        }
    }

    function readE() external view returns (uint16 e) {
        assembly {
            //get the data at E slot
            e := sload(E.slot)
            //0x 0007 0006 000000000000000000000005 00000000000000000000000000000004
            //get the offset and multiply by 8 because shift right takes
            //in the no of bits to shift not no of bytes which offset is
            //to get no of bits we multiply by 8(1 byte = 8 bits)

            e := shr(mul(E.offset, 8), e)
            //after shifting, we have: //0x 000000000000000000000000 00000000000000000000000000000000 0007 0006

            //and operation : //0x 000000000000000000000000 00000000000000000000000000000000 0007 0006
            //and mask      : //0x 000000000000000000000000 00000000000000000000000000000000 0000 ffff
            e := and(e, 0xffff)
        }
    }

    function readF() external view returns (uint8 f) {
        assembly {
            //0x 0007 0006 000000000000000000000005 00000000000000000000000000000004
            f := sload(F.slot)
            //0x 0000 000000000000000000000000 00000000000000000000000000000000 0007
            f := shr(mul(F.offset, 8), f)
        }
    }

    function readD() external view returns (uint96 d) {
        assembly {
            //0x 0007 0006 000000000000000000000005 00000000000000000000000000000004
            d := sload(D.slot)
            //0x 00000000000000000000000000000000 0007 0006 000000000000000000000005
            d := shr(mul(D.offset, 8), d)
            //0x 00000000000000000000000000000000 0000 0000 000000000000000000000005
            d := and(d, 0xffffffffffffffffffffffff)
        }
    }

    function readC() external view returns (uint128 c) {
        assembly {
            //0x 0007 0006 000000000000000000000005 00000000000000000000000000000004
            c := sload(C.slot)
            //0x 0000 0000 000000000000000000000000 00000000000000000000000000000004
            c := and(c, 0xffffffffffffffffffffffffffffffff)
        }
    }

    function setC(uint128 _c) public {
        C = _c;
    }

    function setD(uint96 _d) public {
        D = _d;
    }

    function setE(uint16 _e) public {
        E = _e;
    }

    function setF(uint8 _f) public {
        F = _f;
    }

    function setEYul(uint16 _e) public {
        //assume _e = 10 which in hex is a
        // _e = //0x 0000 0000 000000000000000000000000 0000000000000000000000000000000a

        assembly {
            let slot := sload(E.slot)
            //clean the data we want to change(we want to change E)
            //clean out e from the old val

            //0x 0007 0006 000000000000000000000005 00000000000000000000000000000004
            let clearedE := and(
                slot,
                0xffff0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            )
            //clearedE = 0x 0007 0000 000000000000000000000005 00000000000000000000000000000004

            //shift _e left by the offset of E
            //that means put _e into the position that E occupies in the slot
            let shiftedNewE := shl(mul(E.offset, 8), _e)
            // shiftedNewE = 0x 0000 000a 000000000000000000000000 00000000000000000000000000000000
            let newVal := or(shiftedNewE, clearedE)
            // shiftedNewE = 0x 0000 000a 000000000000000000000000 00000000000000000000000000000000
            //clearedE     = 0x 0007 0000 000000000000000000000005 00000000000000000000000000000004

            //newVal       = 0x 0007 000a 000000000000000000000005 00000000000000000000000000000004

            //store newVal into the slot
            sstore(E.slot, newVal)
        }
    }

    function setFYul(uint8 _f) public {
        //assume _f = 10 which in hex is a
        // _f = 0x 0000 0000 000000000000000000000000 0000000000000000000000000000000a
        assembly {
            let slot := sload(F.slot)
            //clean the data we want to change(we want to change F)
            //clean out f from the old val
            let clearedF := and(
                slot,
                0x0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            )

            //shift _f left by the offset of F
            //that means put _f into the position that F occupies in the slot
            let shiftedNewF := shl(mul(F.offset, 8), _f)
            // shiftedNewF = 0x 000a 0000 000000000000000000000000 00000000000000000000000000000000

            let newVal := or(shiftedNewF, clearedF)

            sstore(F.slot, newVal)
        }
    }

    function setDYul(uint96 _d) public {
        //assume _d = 10 which in hex is a
        // _f = 0x 0000 0000 000000000000000000000000 0000000000000000000000000000000a
        assembly {
            let slot := sload(D.slot)
            //clean the data we want to change(we want to change D)
            //clean out d from the old val
            let clearedD := and(
                slot,
                0xffffffff000000000000000000000000ffffffffffffffffffffffffffffffff
            )
            //shift _d left by the offset of D
            //that means put _d into the position that D occupies in the slot
            let shiftedNewD := shl(mul(D.offset, 8), _d)
            //merge the new value with the old value
            let newVal := or(shiftedNewD, clearedD)

            sstore(D.slot, newVal)
        }
    }

    function setCYul(uint128 _c) public {
        //assume _c = 10 which in hex is a
        // _c = = 0x 0000 0000 000000000000000000000000 0000000000000000000000000000000a
        assembly {
            let slot := sload(C.slot)
            //clean the data we want to change(we want to change C)
            //clean out c from the old val
            let clearedC := and(
                slot,
                0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff
            )
            //shift _c left by the offset of C
            //that means put _c into the position that C occupies in the slot
            //merge the new value with the old value
            let newVal := or(_c, clearedC)

            sstore(C.slot, newVal)
        }
    }
}
