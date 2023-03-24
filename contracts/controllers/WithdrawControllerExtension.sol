// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IERC4626} from '../truefish/interfaces/IERC4626.sol';
import {IWithdrawController} from "../truefish/interfaces/IWithdrawController.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract WithdrawControllerExtension is IWithdrawController {
    function maxWithdraw(address owner) external view returns (uint256) {
        return Math.min(previewRedeem(IERC4626(address(this)).balanceOf(owner)), IERC4626(address(this)).totalAssets());
    }

    function maxRedeem(address owner) external view returns (uint256) {
        return Math.min(IERC4626(address(this)).balanceOf(owner), previewWithdraw(IERC4626(address(this)).totalAssets()));
    }

    function onWithdraw(
        address,
        uint256 assets,
        address,
        address
    ) external view returns (uint256, uint256) {
        return (previewWithdraw(assets), 0);
    }

    function onRedeem(
        address,
        uint256 shares,
        address,
        address
    ) external view returns (uint256, uint256) {
        return (previewRedeem(shares), 0);
    }

    function previewRedeem(uint256 shares) public view returns (uint256) {
        return IERC4626(address(this)).convertToAssets(shares);
    }

    function previewWithdraw(uint256 assets) public view returns (uint256) {
        uint256 totalAssets = IERC4626(address(this)).totalAssets();
        uint256 totalSupply = IERC4626(address(this)).totalSupply();
        if (totalAssets == 0) {
            return 0;
        } else {
            return Math.ceilDiv(assets * totalSupply, totalAssets);
        }
    }
}
