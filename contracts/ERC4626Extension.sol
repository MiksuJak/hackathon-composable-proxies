// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {ERC20Extension} from './ERC20Extension.sol';
import {ERC4626Storage} from "./storages/ERC4626Storage.sol";
import {IDepositController} from "./truefish/interfaces/IDepositController.sol";
import {IWithdrawController} from "./truefish/interfaces/IWithdrawController.sol";

contract ERC4626Extension is ERC20Extension {
    event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);

    event Withdraw(address indexed sender, address indexed receiver, address indexed owner, uint256 assets, uint256 shares);
    
    function ERC4626__init(
        string calldata _name,
        string calldata _symbol,
        uint8 _decimals,
        IERC20Metadata _asset
    ) public {
        ERC20__init(_name, _symbol, _decimals);
        ERC4626Storage.Data storage data = ERC4626Storage.erc4626Storage();
        data.asset = _asset;
    }

    function asset() public view returns (IERC20Metadata _asset) {
        return ERC4626Storage.erc4626Storage().asset;
    }

    function totalAssets() public view returns (uint256 totalManagedAssets) {
        return asset().balanceOf(address(this));
    }

    function convertToShares(uint256 assets) public view returns (uint256 shares) {
        uint256 _totalAssets = totalAssets();
        if (_totalAssets == 0) {
            return assets;
        }
        return (assets * totalSupply()) / _totalAssets;
    }

    function convertToAssets(uint256 shares) public view returns (uint256 assets) {
        uint256 _totalAssets = totalAssets();
        if (_totalAssets == 0) {
            return shares;
        }
        return (shares * _totalAssets) / totalSupply();
    }

    function deposit(uint256 assets, address receiver) public returns (uint256) {
        ERC4626Storage.Data storage data = ERC4626Storage.erc4626Storage();
        (uint256 shares,) = IDepositController(address(this)).onDeposit(msg.sender, assets, receiver);
        _mint(msg.sender, shares);
        data.asset.transferFrom(msg.sender, address(this), assets);
        emit Deposit(msg.sender, receiver, assets, shares);
        return shares;
    }

    function mint(uint256 shares, address receiver) public returns (uint256) {
        ERC4626Storage.Data storage data = ERC4626Storage.erc4626Storage();
        (uint256 assets,) = IDepositController(address(this)).onMint(msg.sender, shares, receiver);
        _mint(msg.sender, shares);
        data.asset.transferFrom(msg.sender, address(this), assets);
        emit Deposit(msg.sender, receiver, assets, shares);
        return assets;
    }

    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) public returns (uint256) {
        ERC4626Storage.Data storage data = ERC4626Storage.erc4626Storage();
        (uint256 shares,) = IWithdrawController(address(this)).onWithdraw(msg.sender, assets, receiver, owner);
        _burnFrom(msg.sender, shares);
        data.asset.transferFrom(address(this), msg.sender, assets);
        emit Withdraw(msg.sender, receiver, owner, assets, shares);
        return shares;
    }

    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) public returns (uint256) {
        ERC4626Storage.Data storage data = ERC4626Storage.erc4626Storage();
        (uint256 assets,) = IWithdrawController(address(this)).onRedeem(msg.sender, shares, receiver, owner);
        _burnFrom(msg.sender, shares);
        data.asset.transferFrom(address(this), msg.sender, assets);
        emit Withdraw(msg.sender, receiver, owner, assets, shares);
        return assets;
    }
}