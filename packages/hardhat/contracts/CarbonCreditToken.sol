// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/// @title CarbonCreditToken
/// @notice Manages fungible carbon credits as ERC-20 tokens for trading.
/// @dev Extends ERC20 for token functionality and AccessControl for role-based permissions.
contract CarbonCreditToken is ERC20, AccessControl {
    /// @notice Role identifier for authorized minters.
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    /// @notice Custom error for unauthorized minting attempts.
    error NotMinter();
    /// @notice Custom error for unauthorized admin actions.
    error NotAdmin();

    /// @notice Initializes the contract with token name and symbol.
    /// @dev Sets the contract deployer as the default admin.
    constructor() ERC20("CarbonCreditToken", "CCT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /// @notice Mints new ERC-20 carbon credit tokens.
    /// @dev Only callable by accounts with MINTER_ROLE.
    /// @param account The address to receive the tokens.
    /// @param amount The number of tokens to mint (1 token = 1 ton CO2).
    function mint(address account, uint256 amount) public {
        if (!hasRole(MINTER_ROLE, msg.sender)) revert NotMinter();
        _mint(account, amount);
    }

    /// @notice Burns (retires) ERC-20 carbon credit tokens.
    /// @dev Callable by token holders to reduce their balance.
    /// @param amount The number of tokens to burn.
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    /// @notice Grants the MINTER_ROLE to an account.
    /// @dev Only callable by accounts with DEFAULT_ADMIN_ROLE.
    /// @param account The address to grant the minter role.
    function grantMinterRole(address account) public {
        if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) revert NotAdmin();
        _grantRole(MINTER_ROLE, account);
    }

    /// @notice Revokes the MINTER_ROLE from an account.
    /// @dev Only callable by accounts with DEFAULT_ADMIN_ROLE.
    /// @param account The address to revoke the minter role from.
    function revokeMinterRole(address account) public {
        if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) revert NotAdmin();
        _revokeRole(MINTER_ROLE, account);
    }
}