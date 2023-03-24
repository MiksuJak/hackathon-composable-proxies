// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@dynamic-contracts/presets/BaseRouter.sol";

/// Example usage of `BaseRouter`, for demonstration only

contract SimpleRouter is BaseRouter {

    address public deployer;

    constructor(Extension[] memory _extensions) BaseRouter(_extensions) {
        deployer = msg.sender;
    }

    /// @dev Returns whether extensions can be set in the given execution context.
    function _canSetExtension() internal view virtual override returns (bool) {
        return msg.sender == deployer;
    }
}