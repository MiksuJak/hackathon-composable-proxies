// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "contracts/ERC4626Extension.sol";
import "@dynamic-contracts/interface/IExtension.sol";

contract ERC4626ExtensionSetup {
    function setupERC4626Extension() public returns (IExtension.Extension memory extension) {
        ERC4626Extension erc4626Extension = new ERC4626Extension();

        IExtension.ExtensionMetadata memory metadata = IExtension.ExtensionMetadata('erc4626', 'erc4626.storage', address(erc4626Extension));
        IExtension.ExtensionFunction[] memory functions = new IExtension.ExtensionFunction[](13);
        functions[0] = IExtension.ExtensionFunction(erc4626Extension.ERC4626__init.selector, 'ERC4626__init(string,string,uint8,address)');
        functions[1] = IExtension.ExtensionFunction(erc4626Extension.name.selector, 'name()');
        functions[2] = IExtension.ExtensionFunction(erc4626Extension.symbol.selector, 'symbol()');
        functions[3] = IExtension.ExtensionFunction(erc4626Extension.decimals.selector, 'decimals()');
        functions[4] = IExtension.ExtensionFunction(erc4626Extension.totalSupply.selector, 'totalSupply()');
        functions[5] = IExtension.ExtensionFunction(erc4626Extension.balanceOf.selector, 'balanceOf(address)');
        functions[6] = IExtension.ExtensionFunction(erc4626Extension.transfer.selector, 'transfer(address,uint256)');
        functions[7] = IExtension.ExtensionFunction(erc4626Extension.transferFrom.selector, 'transferFrom(address,address,uint256)');
        functions[8] = IExtension.ExtensionFunction(erc4626Extension.allowance.selector, 'allowance(address,address)');
        functions[9] = IExtension.ExtensionFunction(erc4626Extension.approve.selector, 'approve(address,uint256)');
        functions[10] = IExtension.ExtensionFunction(erc4626Extension.asset.selector, 'asset()');
        functions[11] = IExtension.ExtensionFunction(erc4626Extension.deposit.selector, 'deposit(uint256,address)');
        functions[12] = IExtension.ExtensionFunction(erc4626Extension.convertToShares.selector, 'convertToShares(uint256)');

        extension = IExtension.Extension(metadata, functions);
    }
}
