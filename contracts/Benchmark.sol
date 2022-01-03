//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Benchmark {
    using ECDSA for bytes32;

    // uints are slightly more efficient than bools because the EVM casts bools to uint
    mapping(address => uint256) public allowList;

    // for public signatures
    address public allowListSigningAddress = address(1337);

    // for merkle tree
    bytes32 public merkleRoot;

    // because we don't want solidity / ethers to think these are view functions
    // or hardhat won't measure the gas
    uint256 public dummy;


    // NOT SAFE FOR PRODUCTION, ANYONE CAN EDIT
    function setAllowList1Mapping(address _buyer) external {
        allowList[_buyer] = 1;
    }

    // NOT SAFE FOR PRODUCTION, ANYONE CAN EDIT
    function setAllowList2SigningAddress(address _signingAddress) external {
        allowListSigningAddress = _signingAddress;
    }

    // NOT SAFE FOR PRODUCTION, ANYONE CAN EDIT
    function setAllowList3MerkleRoot(bytes32 _merkleRoot) external {
        merkleRoot = _merkleRoot;
    }

    function benchmark1Mapping() external {
        require(allowList[msg.sender] == 1, "not allowed");

        //if you execute the following code, the gas will be even lower
        //because the EVM refunds for setting storage to zero

        //allowList[msg.sender] == 0;


        if (false) {
            dummy = 1;
        }
    }

    function benchmark2PublicSignature(bytes calldata _signature) external {
        require(
            allowListSigningAddress ==
                keccak256(
                    abi.encodePacked(
                        "\x19Ethereum Signed Message:\n32",
                        bytes32(uint256(uint160(msg.sender)))
                    )
                ).recover(_signature),
            "not allowed"
        );
        if (false) {
            dummy = 1;
        }
    }

    function benchmark3MerkleTree(bytes32[] calldata merkleProof) external {
        require(
            MerkleProof.verify(
                merkleProof,
                merkleRoot,
                keccak256(
                    abi.encodePacked(msg.sender))),
        "Invalid merkle proof");
        if (false) {
            dummy = 1;
        }
    }
}
