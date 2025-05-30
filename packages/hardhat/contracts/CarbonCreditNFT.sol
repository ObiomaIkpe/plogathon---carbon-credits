// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts@5.0.2/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@5.0.2/access/AccessControl.sol";

/// @title CarbonCreditNFT
/// @notice Manages unique carbon credits as ERC-721 NFTs, with metadata and CO2 tracking.
/// @dev Extends ERC721URIStorage for token URI storage and AccessControl for role-based permissions.
contract CarbonCreditNFT is ERC721URIStorage, AccessControl {
    /// @notice Role identifier for authorized minters.
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    /// @notice Counter for generating unique token IDs.
    uint256 public tokenIdCounter;

    /// @notice Maps token ID to CO2 amount (in tons) for each NFT.
    mapping(uint256 => uint256) public carbonAmount;

    /// @notice Custom error for unauthorized access to minting.
    error NotMinter();
    /// @notice Custom error for unauthorized access to admin functions.
    error NotAdmin();
    /// @notice Custom error for non-owner or non-approved callers attempting to burn.
    error NotOwnerOrApproved();
    /// @notice Custom error for invalid CO2 amount (zero).
    error InvalidCarbonAmount();

    /// @notice Emitted when a new carbon credit NFT is minted.
    /// @param tokenId The ID of the minted NFT.
    /// @param to The address receiving the NFT.
    /// @param carbonTons The CO2 amount (in tons) represented by the NFT.
    /// @param tokenURI The URI storing metadata (e.g., project details).
    event CreditMinted(uint256 indexed tokenId, address indexed to, uint256 carbonTons, string tokenURI);

    /// @notice Emitted when a carbon credit NFT is burned (retired).
    /// @param tokenId The ID of the burned NFT.
    /// @param owner The address of the owner who burned the NFT.
    event CreditBurned(uint256 indexed tokenId, address indexed owner);

    /// @notice Initializes the contract with default admin and minter roles.
    /// @dev Sets the contract deployer as the default admin and initial minter.
    constructor() ERC721("CarbonCreditNFT", "CCNFT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        tokenIdCounter = 0;
    }

    /// @notice Mints a new carbon credit NFT with specified CO2 amount and metadata.
    /// @dev Only callable by accounts with MINTER_ROLE. Increments tokenIdCounter.
    /// @param to The address to receive the NFT.
    /// @param carbonTons The CO2 amount (in tons) represented by the NFT.
    /// @param tokenURI The URI for metadata (e.g., IPFS link to project details).
    /// @return The ID of the newly minted NFT.
    function mint(address to, uint256 carbonTons, string memory tokenURI) public returns (uint256) {
        if (!hasRole(MINTER_ROLE, msg.sender)) revert NotMinter();
        if (carbonTons == 0) revert InvalidCarbonAmount();

        uint256 newTokenId = tokenIdCounter;
        _mint(to, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        carbonAmount[newTokenId] = carbonTons;
        tokenIdCounter++;
        emit CreditMinted(newTokenId, to, carbonTons, tokenURI);
        return newTokenId;
    }

    /// @notice Burns (retires) a carbon credit NFT.
    /// @dev Only callable by the NFT owner or approved address. Emits CreditBurned event.
    /// @param tokenId The ID of the NFT to burn.
    function burn(uint256 tokenId) public {
        if (!_isAuthorized(msg.sender, tokenId)) revert NotOwnerOrApproved();
        _burn(tokenId);
        emit CreditBurned(tokenId, msg.sender);
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

    /// @notice Overrides supportsInterface to handle ERC-721 and AccessControl interfaces.
    /// @param interfaceId The interface ID to check.
    /// @return True if the interface is supported, false otherwise.
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
