// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "contracts/Router.sol";
import "contracts/DepositControllerExtension.sol";
import "contracts/Extension.sol";
import "@dynamic-contracts/interface/IExtension.sol";

contract RouterTest is Test {
    SimpleRouter public router;

    function setUp() public {
        IExtension.Extension[] memory extensions = new IExtension.Extension[](1);

        /* ERC4626 extension */

        /* portfolio extension */

        DepositControllerExtension depositController = new DepositControllerExtension();
        extensions[0].medatada = IExtension.ExtensionMetadata('depositController', 'null.storage', address(depositController));
        extensions[0].functions = new IExtension.ExtensionFunction[](6);
        extensions[0].functions[0] = IExtension.ExtensionFunction(depositController.onDeposit.selector, 'onDeposit(address,uint256,address)');
        extensions[0].functions[1] = IExtension.ExtensionFunction(depositController.onMint.selector, 'onMint(address,uint256,address)');
        extensions[0].functions[2] = IExtension.ExtensionFunction(depositController.previewDeposit.selector, 'previewDeposit(uint256)');
        extensions[0].functions[3] = IExtension.ExtensionFunction(depositController.previewMint.selector, 'previewMint(uint256)');
        extensions[0].functions[4] = IExtension.ExtensionFunction(depositController.maxDeposit.selector, 'maxDeposit(address)');
        extensions[0].functions[5] = IExtension.ExtensionFunction(depositController.maxMint.selector, 'maxMint(address)');

        router = new SimpleRouter(extensions);
    }
}
