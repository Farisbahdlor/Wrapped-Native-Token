// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WrappedEmpressToken is ERC20, Ownable {
    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    // Constructor to initialize the wrapped token (wEMP)
    constructor() ERC20("Wrapped Empress Token", "wEMP") Ownable(msg.sender) {}

    // Deposit function to wrap native EMP tokens to wEMP
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        // Mint an equivalent amount of wEMP tokens to the sender
        _mint(msg.sender, msg.value);

        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw function to unwrap wEMP back to native EMP tokens
    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdraw amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient wrapped token balance");

        // Burn the specified amount of wEMP tokens from the sender's balance
        _burn(msg.sender, amount);

        // Transfer the equivalent amount of native EMP tokens back to the user
        payable(msg.sender).transfer(amount);

        emit Withdraw(msg.sender, amount);
    }

    // Fallback function to handle plain transfers (for native EMP token)
    receive() external payable {
        deposit();
    }
}
