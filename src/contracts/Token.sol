// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    address public minter;

    event MinterRoleChanged(address indexed from, address to);

    constructor() payable ERC20("Decentralized Bank Currency", "DBC") {
        minter = msg.sender;
    }

    function passMinterRole(address dBank) public returns (bool) {
        require(msg.sender == minter, "Error, only owner can pass minter role");
        minter = dBank;

        emit MinterRoleChanged(msg.sender, dBank);
        return true;
    }

    function mint(address account, uint256 amount) public {
        require(
            msg.sender == minter,
            "Error, msg.sender doen not have minter role"
        );
        _mint(account, amount);
    }
}
