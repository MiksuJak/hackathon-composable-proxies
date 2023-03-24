// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Extension.sol";

/// implementation of our contract's logic, notice the lack of local state
/// state is always accessed via the storage library defined above
contract Incrementer {

    function increment() external {
        NumberStorage.Data storage data = NumberStorage.numberStorage();
        data.number++;
    }
}