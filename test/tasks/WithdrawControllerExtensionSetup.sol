// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@dynamic-contracts/interface/IExtension.sol";
import {WithdrawControllerExtension} from "contracts/controllers/WithdrawControllerExtension.sol";

contract WithdrawControllerExtensionSetup {
    function setupWithdrawControllerExtension() public returns (IExtension.Extension memory) {
        WithdrawControllerExtension withdrawController = new WithdrawControllerExtension();

        IExtension.ExtensionMetadata memory metadata = IExtension.ExtensionMetadata('withdrawController', 'null.storage', address(withdrawController));
        IExtension.ExtensionFunction[] memory functions = new IExtension.ExtensionFunction[](6);
        functions[0] = IExtension.ExtensionFunction(withdrawController.onWithdraw.selector, 'onWithdraw(address,uint256,address)');
        functions[1] = IExtension.ExtensionFunction(withdrawController.onRedeem.selector, 'onRedeem(address,uint256,address)');
        functions[2] = IExtension.ExtensionFunction(withdrawController.previewWithdraw.selector, 'previewWithdraw(uint256)');
        functions[3] = IExtension.ExtensionFunction(withdrawController.previewRedeem.selector, 'previewRedeem(uint256)');
        functions[4] = IExtension.ExtensionFunction(withdrawController.maxWithdraw.selector, 'maxWithdraw(address)');
        functions[5] = IExtension.ExtensionFunction(withdrawController.maxRedeem.selector, 'maxRedeem(address)');

        return IExtension.Extension(metadata, functions);
    }
}
