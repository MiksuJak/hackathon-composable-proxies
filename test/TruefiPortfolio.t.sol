// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Token} from "contracts/Token.sol";
import {ERC4626} from "contracts/truefish/ERC4626.sol";
import {DepositController} from "contracts/truefish/controllers/DepositController.sol";
import {IERC4626} from "contracts/truefish/interfaces/IERC4626.sol";

contract TruefiPortfolio is Test {
    address public constant wallet = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;
    address public constant other = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address public constant another = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    ERC4626 public erc4626;
    Token public token;

    function setUp() public {
        token = new Token("Token", "TKN");
        DepositController depositController = new DepositController();
        erc4626 = new ERC4626();
        erc4626.ERC4626__init("ERC4626Test", "E4626T", 6, token, depositController);
    }

    function testBasicInitialize() public {
        assertEq(erc4626.name(), "ERC4626Test");
        assertEq(erc4626.symbol(), "E4626T");
        assertEq(erc4626.decimals(), 6);
    }

    function test_deposit() public {
        token.mint(wallet, 1000);
        token.approve(address(erc4626), 1000);
        IERC4626(address(erc4626)).deposit(1000, wallet);

        assertEq(token.balanceOf(wallet), 0);
        assertEq(token.balanceOf(address(erc4626)), 1000);
        assertEq(erc4626.balanceOf(wallet), 1000);
    }
}
