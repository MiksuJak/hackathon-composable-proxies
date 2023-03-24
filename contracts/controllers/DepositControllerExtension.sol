// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {IERC4626} from '../truefish/interfaces/IERC4626.sol';
import {IDepositController} from "../truefish/interfaces/IDepositController.sol";
import {ERC4626Storage} from "../storages/ERC4626Storage.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract DepositControllerExtension is IDepositController {
    function onDeposit(
        address sender,
        uint256 assets,
        address receiver
    ) external returns (uint256, uint256) {
        return (previewDeposit(assets), 0);
    }

    function onMint(
        address sender,
        uint256 shares,
        address receiver
    ) external returns (uint256, uint256) {
        return (previewMint(shares), 0);
    }

    function previewDeposit(uint256 assets) public view returns (uint256 shares) {
        return IERC4626((address(this))).convertToShares(assets);
    }

    function previewMint(uint256 shares) public view returns (uint256 assets) {
        uint256 totalAssets = IERC4626(address(this)).totalAssets();
        uint256 totalSupply = IERC4626(address(this)).totalSupply();
        if (totalSupply == 0) {
            return shares;
        } else {
            return Math.ceilDiv((shares * totalAssets), totalSupply);
        }
    }

    function maxDeposit(address sender) public view returns (uint256 assets) {
        return type(uint256).max;
    }

    function maxMint(address sender) public view returns (uint256 shares) {
        return previewDeposit(maxDeposit(sender));
    }
}
