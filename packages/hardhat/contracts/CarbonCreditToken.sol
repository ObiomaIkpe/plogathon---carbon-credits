// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts@5.0.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.2/access/AccessControl.sol";

contract CarbonCreditToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    // Custom errors
    error NotMinter();
    error NotAdmin();

    constructor() ERC20("CarbonCreditToken", "CCT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mint(address account, uint256 amount) public {
        if (!hasRole(MINTER_ROLE, msg.sender)) revert NotMinter();
        _mint(account, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function grantMinterRole(address account) public {
        if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) revert NotAdmin();
        _grantRole(MINTER_ROLE, account);
    }

    function revokeMinterRole(address account) public {
        if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) revert NotAdmin();
        _revokeRole(MINTER_ROLE, account);
    }
}