// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {IDepositController} from "../interfaces/IDepositController.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {IERC4626} from "../interfaces/IERC4626.sol";

contract DepositController is IDepositController, Initializable {
    function maxDeposit(address receiver) public view virtual returns (uint256) {
        return type(uint256).max;
    }

    function maxMint(address receiver) public view virtual returns (uint256) {
        return previewDeposit(maxDeposit(receiver));
    }

    function onDeposit(
        address,
        uint256 assets,
        address receiver
    ) public view virtual returns (uint256, uint256) {
        return (previewDeposit(assets), 0);
    }

    function onMint(
        address,
        uint256 shares,
        address receiver
    ) public view virtual returns (uint256, uint256) {
        return (previewMint(shares), 0);
    }

    function previewDeposit(uint256 assets) public view returns (uint256 shares) {
        return IERC4626(msg.sender).convertToShares(assets);
    }

    function previewMint(uint256 shares) public view returns (uint256) {
        uint256 totalAssets = IERC4626(msg.sender).totalAssets();
        uint256 totalSupply = IERC4626(msg.sender).totalSupply();
        if (totalSupply == 0) {
            return shares;
        } else {
            return Math.ceilDiv((shares * totalAssets), totalSupply);
        }
    }
}
