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
        extensions[0].functions = new IExtension.ExtensionFunction[](11);
        extensions[0].functions[0] = IExtension.ExtensionFunction(erc20Extension.initialize.selector, 'initialize(string,string,uint8)');
        extensions[0].functions[1] = IExtension.ExtensionFunction(erc20Extension.name.selector, 'name()');
        extensions[0].functions[2] = IExtension.ExtensionFunction(erc20Extension.symbol.selector, 'symbol()');
        extensions[0].functions[3] = IExtension.ExtensionFunction(erc20Extension.decimals.selector, 'decimals()');
        extensions[0].functions[4] = IExtension.ExtensionFunction(erc20Extension.totalSupply.selector, 'totalSupply()');
        extensions[0].functions[5] = IExtension.ExtensionFunction(erc20Extension.balanceOf.selector, 'balanceOf(address)');
        extensions[0].functions[6] = IExtension.ExtensionFunction(erc20Extension.transfer.selector, 'transfer(address,uint256)');
        extensions[0].functions[7] = IExtension.ExtensionFunction(erc20Extension.transferFrom.selector, 'transferFrom(address,address,uint256)');
        extensions[0].functions[8] = IExtension.ExtensionFunction(erc20Extension.allowance.selector, 'allowance(address,address)');
        extensions[0].functions[9] = IExtension.ExtensionFunction(erc20Extension.approve.selector, 'approve(address,uint256)');
        extensions[0].functions[10] = IExtension.ExtensionFunction(erc20Extension.mint.selector, 'mint(address,uint256)');

        router = new SimpleRouter(extensions);

        ERC20Extension(address(router)).initialize("ERC20Test", "E20T", 6);
    }

    function testBasicInitialize() public {
        assertEq(ERC20Extension(address(router)).name(), "ERC20Test");
        assertEq(ERC20Extension(address(router)).symbol(), "E20T");
        assertEq(ERC20Extension(address(router)).decimals(), 6);
    }

    function testInitializeCanBeCalledOnlyOnce() public {
        try ERC20Extension(address(router)).initialize("ERC20Second", "E20TT", 4) {
            assert(false);
        } catch {}
    }

    function testBalanceOfEqualsZeroAtBeginning() public {
        assertEq(ERC20Extension(address(router)).balanceOf(address(1)), 0);
    }

    function testBasicMint() public {
        ERC20Extension(address(router)).mint(address(5), 25);
        assertEq(ERC20Extension(address(router)).balanceOf(address(5)), 25);
    }

    function testMintIncreasesTotalSupply() public {
        ERC20Extension(address(router)).mint(address(5), 50);
        assertEq(ERC20Extension(address(router)).totalSupply(), 50);
    }

    function testAllowanceEqualsZeroAtBeginning() public {
        assertEq(ERC20Extension(address(router)).allowance(address(1), address(2)), 0);
    }

    function testApprove() public {
        ERC20Extension(address(router)).approve(address(5), 25);
        assertEq(ERC20Extension(address(router)).allowance(address(this), address(5)), 25);
    }

    function testTransfer() public {
        ERC20Extension(address(router)).mint(address(this), 500);
        ERC20Extension(address(router)).transfer(address(5), 450);
        assertEq(ERC20Extension(address(router)).balanceOf(address(this)), 50);
        assertEq(ERC20Extension(address(router)).balanceOf(address(5)), 450);
    }

    function testTransferZero() public {
        ERC20Extension(address(router)).mint(address(this), 500);
        ERC20Extension(address(router)).transfer(address(5), 0);
        assertEq(ERC20Extension(address(router)).balanceOf(address(this)), 500);
        assertEq(ERC20Extension(address(router)).balanceOf(address(5)), 0);
    }

    function testTransferEverything() public {
        ERC20Extension(address(router)).mint(address(this), 500);
        ERC20Extension(address(router)).transfer(address(5), 500);
        assertEq(ERC20Extension(address(router)).balanceOf(address(this)), 0);
        assertEq(ERC20Extension(address(router)).balanceOf(address(5)), 500);
    }

    function testTransferOverAmount() public {
        ERC20Extension(address(router)).mint(address(this), 500);
        try ERC20Extension(address(router)).transfer(address(5), 505) {
            assert(false);
        } catch {}
    }

    function testTransferDoesntChangeTotalSupply() public {
        ERC20Extension(address(router)).mint(address(this), 500);
        ERC20Extension(address(router)).transfer(address(5), 123);
        assertEq(ERC20Extension(address(router)).totalSupply(), 500);
    }

    function testBasicTransferFrom() public {
        ERC20Extension(address(router)).mint(address(this), 500);
        ERC20Extension(address(router)).approve(address(this), 1000);
        ERC20Extension(address(router)).transferFrom(address(this), address(this), 123);
        assertEq(ERC20Extension(address(router)).balanceOf(address(this)), 500);
    }

    function testTransferFromToItself() public {
        ERC20Extension(address(router)).mint(address(this), 500);
        ERC20Extension(address(router)).approve(address(this), 1000);
        ERC20Extension(address(router)).transferFrom(address(this), address(5), 200);
        assertEq(ERC20Extension(address(router)).balanceOf(address(this)), 300);
        assertEq(ERC20Extension(address(router)).balanceOf(address(5)), 200);
    }

    function testTransferFromWithoutAllowance() public {
        ERC20Extension(address(router)).mint(address(this), 500);
        try ERC20Extension(address(router)).transferFrom(address(this), address(5), 200) {
            assert(false);
        } catch {}
    }

    function testTransferFromWithNotEnoughAllowance() public {
        ERC20Extension(address(router)).mint(address(this), 500);
        ERC20Extension(address(router)).approve(address(this), 100);
        try ERC20Extension(address(router)).transferFrom(address(this), address(5), 200) {
            assert(false);
        } catch {}
    }
}
