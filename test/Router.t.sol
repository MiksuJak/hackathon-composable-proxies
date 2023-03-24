// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "contracts/Router.sol";
import "contracts/Extension.sol";
import "contracts/Incrementer.sol";
import "@dynamic-contracts/interface/IExtension.sol";

contract RouterTest is Test {
    SimpleRouter public router;


    function setUp() public {
        Number number = new Number();

        IExtension.Extension[] memory extensions = new IExtension.Extension[](2);
        extensions[0].metadata = IExtension.ExtensionMetadata('number', 'qwe.storage', address(number));
        extensions[0].functions = new IExtension.ExtensionFunction[](2);
        extensions[0].functions[0] = IExtension.ExtensionFunction(number.setNumber.selector, 'setNumber(uint256)');
        extensions[0].functions[1] = IExtension.ExtensionFunction(number.getNumber.selector, 'getNumber()');

        Incrementer incrementer = new Incrementer();
        extensions[1].metadata = IExtension.ExtensionMetadata('incrementer', 'incrementer.storage', address(incrementer));
        extensions[1].functions = new IExtension.ExtensionFunction[](1);
        extensions[1].functions[0] = IExtension.ExtensionFunction(incrementer.increment.selector, 'increment()');

        router = new SimpleRouter(extensions);
    }

    function testSetNumber(uint256 x) public {
        Number(address(router)).setNumber(x);
        assertEq(Number(address(router)).getNumber(), x);
    }

    function testIncrement() public {
        Number(address(router)).setNumber(5);
        Incrementer(address(router)).increment();
        assertEq(Number(address(router)).getNumber(), 6);
    }
}
