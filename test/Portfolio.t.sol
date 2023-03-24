// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "contracts/Router.sol";
import "@dynamic-contracts/interface/IExtension.sol";
import {ERC4626ExtensionSetup} from "./tasks/ERC4626ExtensionSetup.sol";
import {DepositControllerExtensionSetup} from "./tasks/DepositControllerExtensionSetup.sol";
import {Token} from "contracts/Token.sol";
import {ERC4626Extension} from "contracts/ERC4626Extension.sol";
import {IERC4626} from "contracts/truefish/interfaces/IERC4626.sol";

contract RouterTest is Test, ERC4626ExtensionSetup, DepositControllerExtensionSetup {
    address public constant wallet = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;
    address public constant other = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address public constant another = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    SimpleRouter public router;
    Token public token;

    function setUp() public {
        token = new Token("Token", "TKN");

        IExtension.Extension[] memory extensions = new IExtension.Extension[](2);
        extensions[0] = setupERC4626Extension();
        extensions[1] = setupDepositControllerExtension();

        router = new SimpleRouter(extensions);

        ERC4626Extension(address(router)).ERC4626__init("ERC4626Test", "E4626T", 6, token);
    }

    function testBasicInitialize() public {
        assertEq(ERC4626Extension(address(router)).name(), "ERC4626Test");
        assertEq(ERC4626Extension(address(router)).symbol(), "E4626T");
        assertEq(ERC4626Extension(address(router)).decimals(), 6);
    }

    function test_deposit() public {
        token.mint(wallet, 1000);
        token.approve(address(router), 1000);
        IERC4626(address(router)).deposit(1000, wallet);

        assertEq(token.balanceOf(wallet), 0);
        assertEq(token.balanceOf(address(router)), 1000);
        assertEq(IERC4626(address(router)).balanceOf(wallet), 1000);
    }
}
