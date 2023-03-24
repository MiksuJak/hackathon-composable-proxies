// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "contracts/Router.sol";
import "contracts/Extension.sol";
import "@dynamic-contracts/interface/IExtension.sol";
import {WithdrawControllerExtensionSetup} from "./tasks/WithdrawControllerExtensionSetup.sol";

contract WithdrawControllerExtensionTest is Test, WithdrawControllerExtensionSetup {
    SimpleRouter public router;

    function setUp() public {
        IExtension.Extension[] memory extensions = new IExtension.Extension[](1);
        extensions[0] = setupWithdrawControllerExtension();
        router = new SimpleRouter(extensions);
    }
}
