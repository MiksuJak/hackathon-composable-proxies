// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IDepositController} from "./interfaces/IDepositController.sol";
import {IWithdrawController} from "./interfaces/IWithdrawController.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {ERC20} from './ERC20.sol';

contract ERC4626 is ERC20 {
    IERC20Metadata public asset;
    IDepositController public depositController;

    event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);

    event Withdraw(address indexed sender, address indexed receiver, address indexed owner, uint256 assets, uint256 shares);
    
    function ERC4626__init(
        string calldata _name,
        string calldata _symbol,
        uint8 _decimals,
        IERC20Metadata _asset,
        IDepositController _depositController
    ) public {
        ERC20__init(_name, _symbol, _decimals);
        asset = _asset;
        depositController = _depositController;
    }

    function totalAssets() public view returns (uint256 totalManagedAssets) {
        return asset.balanceOf(address(this));
    }

    function convertToShares(uint256 assets) public view returns (uint256 shares) {
        uint256 totalAssets = totalAssets();
        if (totalAssets == 0) {
            return assets;
        }
        return (assets * totalSupply) / totalAssets;
    }

    function convertToAssets(uint256 shares) public view returns (uint256 assets) {
        uint256 totalAssets = totalAssets();
        if (totalAssets == 0) {
            return shares;
        }
        return (shares * totalAssets) / totalSupply;
    }

    function deposit(uint256 assets, address receiver) public returns (uint256) {
        (uint256 shares,) = depositController.onDeposit(msg.sender, assets, receiver);
        _mint(msg.sender, shares);
        asset.transferFrom(msg.sender, address(this), assets);
        emit Deposit(msg.sender, receiver, assets, shares);
    }

    // function mint(uint256 shares, address receiver) public returns (uint256 assets) {
    //     return 0;
    // }

    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) public returns (uint256) {
        return 0;
    }

    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) public returns (uint256 assets) {
        return 0;
    }
}