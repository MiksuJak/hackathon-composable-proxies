// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@dynamic-contracts/interface/IExtension.sol";
import {DepositControllerExtension} from "contracts/controllers/DepositControllerExtension.sol";

contract DepositControllerExtensionSetup {
    function setupDepositControllerExtension() public returns (IExtension.Extension memory) {
        DepositControllerExtension depositController = new DepositControllerExtension();

        IExtension.ExtensionMetadata memory metadata = IExtension.ExtensionMetadata('depositController', 'null.storage', address(depositController));
        IExtension.ExtensionFunction[] memory functions = new IExtension.ExtensionFunction[](6);
        functions[0] = IExtension.ExtensionFunction(depositController.onDeposit.selector, 'onDeposit(address,uint256,address)');
        functions[1] = IExtension.ExtensionFunction(depositController.onMint.selector, 'onMint(address,uint256,address)');
        functions[2] = IExtension.ExtensionFunction(depositController.previewDeposit.selector, 'previewDeposit(uint256)');
        functions[3] = IExtension.ExtensionFunction(depositController.previewMint.selector, 'previewMint(uint256)');
        functions[4] = IExtension.ExtensionFunction(depositController.maxDeposit.selector, 'maxDeposit(address)');
        functions[5] = IExtension.ExtensionFunction(depositController.maxMint.selector, 'maxMint(address)');

        return IExtension.Extension(metadata, functions);
    }
}
