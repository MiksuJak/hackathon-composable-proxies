// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "contracts/Router.sol";
import "contracts/ERC4626Extension.sol";
import "@dynamic-contracts/interface/IExtension.sol";
import {Token} from "contracts/Token.sol";

contract ERC4626ExtensionTest is Test {
    SimpleRouter public router;
    Token public token;


    function setUp() public {
        token = new Token("Token", "TKN");

        ERC4626Extension erc4626Extension = new ERC4626Extension();

        IExtension.Extension[] memory extensions = new IExtension.Extension[](1);
        extensions[0].metadata = IExtension.ExtensionMetadata('erc4626', 'erc4626.storage', address(erc4626Extension));
        extensions[0].functions = new IExtension.ExtensionFunction[](12);
        extensions[0].functions[0] = IExtension.ExtensionFunction(erc4626Extension.ERC4626__init.selector, 'ERC4626__init(string,string,uint8,address)');
        extensions[0].functions[1] = IExtension.ExtensionFunction(erc4626Extension.name.selector, 'name()');
        extensions[0].functions[2] = IExtension.ExtensionFunction(erc4626Extension.symbol.selector, 'symbol()');
        extensions[0].functions[3] = IExtension.ExtensionFunction(erc4626Extension.decimals.selector, 'decimals()');
        extensions[0].functions[4] = IExtension.ExtensionFunction(erc4626Extension.totalSupply.selector, 'totalSupply()');
        extensions[0].functions[5] = IExtension.ExtensionFunction(erc4626Extension.balanceOf.selector, 'balanceOf(address)');
        extensions[0].functions[6] = IExtension.ExtensionFunction(erc4626Extension.transfer.selector, 'transfer(address,uint256)');
        extensions[0].functions[7] = IExtension.ExtensionFunction(erc4626Extension.transferFrom.selector, 'transferFrom(address,address,uint256)');
        extensions[0].functions[8] = IExtension.ExtensionFunction(erc4626Extension.allowance.selector, 'allowance(address,address)');
        extensions[0].functions[9] = IExtension.ExtensionFunction(erc4626Extension.approve.selector, 'approve(address,uint256)');
        extensions[0].functions[10] = IExtension.ExtensionFunction(erc4626Extension.mint.selector, 'mint(address,uint256)');
        extensions[0].functions[11] = IExtension.ExtensionFunction(erc4626Extension.asset.selector, 'asset()');

        router = new SimpleRouter(extensions);

        ERC4626Extension(address(router)).ERC4626__init("ERC4626Test", "E4626T", 6, token);
    }

    function testBasicInitialize() public {
        assertEq(ERC4626Extension(address(router)).name(), "ERC4626Test");
        assertEq(ERC4626Extension(address(router)).symbol(), "E4626T");
        assertEq(ERC4626Extension(address(router)).decimals(), 6);
    }

    function testInitializeCanBeCalledOnlyOnce() public {
        try ERC4626Extension(address(router)).ERC4626__init("ERC4626Second", "E4626TT", 4, token) {
            assert(false);
        } catch {}
    }
}
