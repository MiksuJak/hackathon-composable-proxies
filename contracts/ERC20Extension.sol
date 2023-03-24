// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "./storages/ERC20Storage.sol";

contract ERC20Extension is IERC20 {
    function initialize(
        string calldata _name,
        string calldata _symbol,
        uint8 _decimals
    ) public {
        ERC20Storage.Data storage data = ERC20Storage.erc20Storage();
        require(!data.initialized, "Already initialized");
        data.name = _name;
        data.symbol = _symbol;
        data.decimals = _decimals;
        data.initialized = true;
    }

    function name() public view returns (string memory) {
        return ERC20Storage.erc20Storage().name;
    }

    function symbol() public view returns (string memory){
        return ERC20Storage.erc20Storage().symbol;
    }

    function decimals() public view returns (uint8){
        return ERC20Storage.erc20Storage().decimals;
    }

    function totalSupply() public view returns (uint256){
        return ERC20Storage.erc20Storage().totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return ERC20Storage.erc20Storage().balances[_owner];
    }

    function mint(address _owner, uint256 value) public {
        ERC20Storage.Data storage data = ERC20Storage.erc20Storage();
        data.balances[_owner] += value;
    }


    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        ERC20Storage.Data storage data = ERC20Storage.erc20Storage();

        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

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

    function transfer(address _to, uint256 _value) public returns (bool success){
        _transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        return  false;
    }
    function approve(address _spender, uint256 _value) public returns (bool success){
        return  false;
    }
    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        return  0;
    }
}