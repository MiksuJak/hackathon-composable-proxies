// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library ERC20Storage {
    /// specify the storage location, needs to be unique
    bytes32 public constant STORAGE_POSITION = keccak256("ERC20.storage");

    /// the state data struct
    struct Data {
        bool initialized;
        string name;
        string symbol;
        uint8 decimals;
        uint256 totalSupply;
        mapping(address => uint256) balances;
        mapping(address => mapping(address => uint256)) allowances;
    }

    /// state accessor, always use this to access the state data
    function erc20Storage() internal pure returns (Data storage extensionStorage) {
        bytes32 position = STORAGE_POSITION;
        assembly {
            extensionStorage.slot := position
        }
    }
}
