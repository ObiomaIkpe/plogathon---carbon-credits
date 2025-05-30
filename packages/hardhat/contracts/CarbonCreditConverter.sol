// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "./CarbonCreditNFT.sol";
import "./CarbonCreditToken.sol";

/// @title CarbonCreditConverter
/// @notice Converts ERC-721 carbon credit NFTs to ERC-20 tokens for trading.
/// @dev Burns NFTs and mints equivalent ERC-20 tokens to prevent double counting.
contract CarbonCreditConverter {
    /// @notice Reference to the CarbonCreditNFT contract.
    CarbonCreditNFT public immutable nftContract;
    /// @notice Reference to the CarbonCreditToken contract.
    CarbonCreditToken public immutable tokenContract;

    /// @notice Custom error for non-owners attempting to convert NFTs.
    error NotNFTOwner();
    /// @notice Custom error for unapproved NFT transfers.
    error NotApproved();
    /// @notice Custom error for NFTs with invalid CO2 amounts.
    error InvalidCarbonAmount();

    /// @notice Emitted when an NFT is converted to ERC-20 tokens.
    /// @param user The address converting the NFT.
    /// @param tokenId The ID of the burned NFT.
    /// @param carbonTons The CO2 amount converted to ERC-20 tokens.
    event ConvertedToTokens(address indexed user, uint256 indexed tokenId, uint256 carbonTons);

    /// @notice Initializes the contract with NFT and token contract addresses.
    /// @param _nftContract The address of the CarbonCreditNFT contract.
    /// @param _tokenContract The address of the CarbonCreditToken contract.
    constructor(address _nftContract, address _tokenContract) {
        nftContract = CarbonCreditNFT(_nftContract);
        tokenContract = CarbonCreditToken(_tokenContract);
    }

    /// @notice Converts an ERC-721 NFT to ERC-20 tokens.
    /// @dev Burns the NFT and mints equivalent ERC-20 tokens (1 token = 1 ton CO2).
    /// @param tokenId The ID of the NFT to convert.
    function convertNFTtoTokens(uint256 tokenId) public {
        if (nftContract.ownerOf(tokenId) != msg.sender) revert NotNFTOwner();
        if (!nftContract.isApprovedForAll(msg.sender, address(this)) && nftContract.getApproved(tokenId) != address(this))
            revert NotApproved();

        uint256 carbonTons = nftContract.carbonAmount(tokenId);
        if (carbonTons == 0) revert InvalidCarbonAmount();

        nftContract.burn(tokenId);
        tokenContract.mint(msg.sender, carbonTons);

        emit ConvertedToTokens(msg.sender, tokenId, carbonTons);
    }
}