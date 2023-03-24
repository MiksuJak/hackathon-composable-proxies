// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "contracts/Router.sol";
import "contracts/Extension.sol";
import "@dynamic-contracts/interface/IExtension.sol";

contract RouterTest is Test {
    SimpleRouter public router;
    Number public number;


    function setUp() public {
        number = new Number();

        IExtension.Extension[] memory extensions = new IExtension.Extension[](1);
        extensions[0].metadata = IExtension.ExtensionMetadata('number', 'number.storage', address(number));
        extensions[0].functions = new IExtension.ExtensionFunction[](2);
        extensions[0].functions[0] = IExtension.ExtensionFunction(number.setNumber.selector, 'setNumber(uint256)');
        extensions[0].functions[1] = IExtension.ExtensionFunction(number.getNumber.selector, 'getNumber()');

        router = new SimpleRouter(extensions);
    }

    function testSetNumber(uint256 x) public {
        Number(address(router)).setNumber(x);
        assertEq(Number(address(router)).getNumber(), x);
    }
}
