// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "./storages/ERC4626Storage.sol";

contract ERC20Extension is IERC20 {
    function initialize(
        string calldata _name,
        string calldata _symbol,
        uint8 _decimals
    ) public {
        ERC4626Storage.Data storage data = ERC4626Storage.erc4626Storage();
        require(!data.initialized, "Already initialized");

        data.name = _name;
        data.symbol = _symbol;
        data.decimals = _decimals;
        data.initialized = true;
    }

    function name() public view returns (string memory) {
        return ERC4626Storage.erc4626Storage().name;
    }

    function symbol() public view returns (string memory) {
        return ERC4626Storage.erc4626Storage().symbol;
    }

    function decimals() public view returns (uint8) {
        return ERC4626Storage.erc4626Storage().decimals;
    }

    function totalSupply() public view returns (uint256) {
        return ERC4626Storage.erc4626Storage().totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256 balance) {
        return ERC4626Storage.erc4626Storage().balances[owner];
    }

    function transfer(address to, uint256 amount) public returns (bool success) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from, 
        address to, 
        uint256 amount
    ) public returns (bool success) {
        _spendAllowance(from, msg.sender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256 remaining) {
        return ERC4626Storage.erc4626Storage().allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool success) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function _mint(address owner, uint256 amount) internal {
        ERC4626Storage.Data storage data = ERC4626Storage.erc4626Storage();
        require(type(uint256).max - amount > data.balances[owner], "uint overflow in mint");
        data.balances[owner] += amount;
        data.totalSupply += amount;
    }

    function _burn(uint256 amount) internal {
        ERC4626Storage.Data storage data = ERC4626Storage.erc4626Storage();
        require(data.balances[msg.sender] >= amount, "Not enough shares to burn");
        data.balances[msg.sender] -= amount;
        data.totalSupply -= amount;
    }

    function _burnFrom(address owner, uint256 amount) internal {
        ERC4626Storage.Data storage data = ERC4626Storage.erc4626Storage();
        require(data.balances[owner] >= amount, "Not enough shares to burn");
        data.balances[owner] -= amount;
        data.totalSupply -= amount;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        ERC4626Storage.Data storage data = ERC4626Storage.erc4626Storage();

        uint256 fromBalance = data.balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            data.balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            data.balances[to] += amount;
        }

        emit Transfer(from, to, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        ERC4626Storage.Data storage data = ERC4626Storage.erc4626Storage();

        data.allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
}
