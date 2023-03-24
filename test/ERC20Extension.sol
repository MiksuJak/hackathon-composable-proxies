// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "contracts/Router.sol";
import "contracts/ERC20Extension.sol";
import "@dynamic-contracts/interface/IExtension.sol";

contract RouterTest is Test {
    SimpleRouter public router;


    function setUp() public {
        ERC20Extension erc20Extension = new ERC20Extension();

        IExtension.Extension[] memory extensions = new IExtension.Extension[](1);
        extensions[0].metadata = IExtension.ExtensionMetadata('erc20', 'erc20.storage', address(erc20Extension));
        extensions[0].functions = new IExtension.ExtensionFunction[](6);
        extensions[0].functions[0] = IExtension.ExtensionFunction(erc20Extension.name.selector, 'name()');
        extensions[0].functions[1] = IExtension.ExtensionFunction(erc20Extension.symbol.selector, 'symbol()');
        extensions[0].functions[2] = IExtension.ExtensionFunction(erc20Extension.balanceOf.selector, 'balanceOf(address)');
        extensions[0].functions[3] = IExtension.ExtensionFunction(erc20Extension.mint.selector, 'mint(address,uint256)');
        extensions[0].functions[4] = IExtension.ExtensionFunction(erc20Extension.transfer.selector, 'transfer(address,uint256)');
        extensions[0].functions[5] = IExtension.ExtensionFunction(erc20Extension.initialize.selector, 'initialize(string,string,uint8)');

        router = new SimpleRouter(extensions);

        ERC20Extension(address(router)).initialize("ERC20Test", "E20T", 6);
    }

    function testName() public {
        assertEq(ERC20Extension(address(router)).name(), "ERC20Test");
    }
}
