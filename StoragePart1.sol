// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

contract StoragePart1 {
    uint128 public C = 4; //32 digits -- 16 bytes
    uint96 public D = 5; //24 digits -- 12 bytes
    uint16 public E = 6; //4 digits  -- 2 bytes
    uint8 public F = 7; //4 digits  -- 2 bytes

    function readBySlot(uint256 slot) public view returns (bytes32 value) {
        assembly {
            value := sload(slot)
        }
    }

    //0x 0007 0006 000000000000000000000005 00000000000000000000000000000004

    function readE() external view returns (uint16 e) {
        assembly {
            //get the data at E slot
            //0x 0007 0006 000000000000000000000005 00000000000000000000000000000004
            e := sload(E.slot)
            //get the offset and multiply by 8 because shift right takes
            //in the no of bits to shift not no of bytes which offset is
            //to get no of bits we multiply by 8(1 byte = 8 bits)

            //after shifting, we have: //0x 000000000000000000000000 00000000000000000000000000000000 0007 0006
            e := shr(mul(E.offset, 8), e)

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
}
