// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract ERC20 is IERC20 {
    bool initialized;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;

    function ERC20__init(
        string calldata _name,
        string calldata _symbol,
        uint8 _decimals
    ) public {
        require(!initialized, "Already initialized");

        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        initialized = true;
    }

    function balanceOf(address owner) public view returns (uint256 balance) {
        return balances[owner];
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
        return allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool success) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function _mint(address owner, uint256 amount) internal {
        require(type(uint256).max - amount > balances[owner], "uint overflow in mint");
        balances[owner] += amount;
        totalSupply += amount;
    }

    function _burn(uint256 amount) internal {
        require(balances[msg.sender] >= amount, "Not enough shares to burn");
        balances[msg.sender] -= amount;
        totalSupply -= amount;
    }

    function _burnFrom(address owner, uint256 amount) internal {
        require(balances[owner] >= amount, "Not enough shares to burn");
        balances[owner] -= amount;
        totalSupply -= amount;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");


        uint256 fromBalance = balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            balances[to] += amount;
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


        allowances[owner][spender] = amount;
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
