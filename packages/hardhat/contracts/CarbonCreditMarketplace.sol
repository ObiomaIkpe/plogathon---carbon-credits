// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "./CarbonCreditNFT.sol";
import "./CarbonCreditToken.sol";

/// @title CarbonCreditMarketplace
/// @notice Facilitates trading of ERC-721 NFTs and ERC-20 carbon credit tokens.
/// @dev Supports listing, buying, and canceling for both token types using ETH payments.
contract CarbonCreditMarketplace {
    /// @notice Reference to the CarbonCreditNFT contract.
    CarbonCreditNFT public immutable nftContract;
    /// @notice Reference to the CarbonCreditToken contract.
    CarbonCreditToken public immutable tokenContract;

    /// @notice Structure for NFT listings.
    struct NFTListing {
        uint256 tokenId;
        address seller;
        uint256 price; // Price in wei
        bool active;
    }

    /// @notice Structure for ERC-20 token listings.
    struct TokenListing {
        address seller;
        uint256 amount; // Amount of ERC-20 tokens
        uint256 price; // Price in wei
        bool active;
    }

    /// @notice Maps token ID to NFT listing details.
    mapping(uint256 => NFTListing) public nftListings;
    /// @notice Maps listing ID to ERC-20 token listing details.
    mapping(uint256 => TokenListing) public tokenListings;
    /// @notice Counter for NFT listings.
    uint256 public nftListingCount;
    /// @notice Counter for ERC-20 token listings.
    uint256 public tokenListingCount;

    /// @notice Custom error for non-owners attempting to list or cancel.
    error NotNFTOwner();
    /// @notice Custom error for unapproved NFT or token transfers.
    error NotApproved();
    /// @notice Custom error for inactive listings.
    error ListingNotActive();
    /// @notice Custom error for insufficient ETH payment.
    error InsufficientPayment();
    /// @notice Custom error for insufficient ERC-20 token balance.
    error InsufficientTokenBalance();
    /// @notice Custom error for insufficient ERC-20 token allowance.
    error InsufficientTokenAllowance();
    /// @notice Custom error when seller no longer owns the NFT.
    error SellerNoLongerOwns();

    /// @notice Emitted when an NFT is listed for sale.
    /// @param tokenId The ID of the listed NFT.
    /// @param seller The address of the seller.
    /// @param price The listing price in wei.
    event NFTListed(uint256 indexed tokenId, address indexed seller, uint256 price);

    /// @notice Emitted when ERC-20 tokens are listed for sale.
    /// @param listingId The ID of the token listing.
    /// @param seller The address of the seller.
    /// @param amount The amount of tokens listed.
    /// @param price The listing price in wei.
    event TokenListed(uint256 indexed listingId, address indexed seller, uint256 amount, uint256 price);

    /// @notice Emitted when an NFT is sold.
    /// @param tokenId The ID of the sold NFT.
    /// @param buyer The address of the buyer.
    /// @param price The sale price in wei.
    event NFTSold(uint256 indexed tokenId, address indexed buyer, uint256 price);

    /// @notice Emitted when ERC-20 tokens are sold.
    /// @param listingId The ID of the token listing.
    /// @param buyer The address of the buyer.
    /// @param amount The amount of tokens sold.
    /// @param price The sale price in wei.
    event TokenSold(uint256 indexed listingId, address indexed buyer, uint256 amount, uint256 price);

    /// @notice Initializes the contract with NFT and token contract addresses.
    /// @param _nftContract The address of the CarbonCreditNFT contract.
    /// @param _tokenContract The address of the CarbonCreditToken contract.
    constructor(address _nftContract, address _tokenContract) {
        nftContract = CarbonCreditNFT(_nftContract);
        tokenContract = CarbonCreditToken(_tokenContract);
    }

    /// @notice Lists an ERC-721 NFT for sale.
    /// @dev Requires the caller to own the NFT and approve the marketplace.
    /// @param tokenId The ID of the NFT to list.
    /// @param price The listing price in wei.
    function listNFT(uint256 tokenId, uint256 price) public {
        if (nftContract.ownerOf(tokenId) != msg.sender) revert NotNFTOwner();
        if (nftContract.getApproved(tokenId) != address(this)) revert NotApproved();

        nftListings[tokenId] = NFTListing(tokenId, msg.sender, price, true);
        nftListingCount++;
        emit NFTListed(tokenId, msg.sender, price);
    }

    /// @notice Lists ERC-20 tokens for sale.
    /// @dev Requires sufficient balance and allowance for the marketplace.
    /// @param amount The amount of tokens to list.
    /// @param price The listing price in wei.
    function listTokens(uint256 amount, uint256 price) public {
        if (tokenContract.balanceOf(msg.sender) < amount) revert InsufficientTokenBalance();
        if (tokenContract.allowance(msg.sender, address(this)) < amount) revert InsufficientTokenAllowance();

        tokenListings[tokenListingCount] = TokenListing(msg.sender, amount, price, true);
        tokenListingCount++;
        emit TokenListed(tokenListingCount - 1, msg.sender, amount, price);
    }

    /// @notice Purchases an ERC-721 NFT from the marketplace.
    /// @dev Requires sufficient ETH and an active listing. Refunds excess ETH.
    /// @param tokenId The ID of the NFT to buy.
    function buyNFT(uint256 tokenId) public payable {
        NFTListing memory listing = nftListings[tokenId];
        if (!listing.active) revert ListingNotActive();
        if (msg.value < listing.price) revert InsufficientPayment();
        if (nftContract.ownerOf(tokenId) != listing.seller) revert SellerNoLongerOwns();

        nftListings[tokenId].active = false;
        nftContract.safeTransferFrom(listing.seller, msg.sender, tokenId);
        payable(listing.seller).transfer(listing.price);

        emit NFTSold(tokenId, msg.sender, listing.price);

        if (msg.value > listing.price) {
            payable(msg.sender).transfer(msg.value - listing.price);
        }
    }

    /// @notice Purchases ERC-20 tokens from the marketplace.
    /// @dev Requires sufficient ETH and an active listing. Refunds excess ETH.
    /// @param listingId The ID of the token listing to buy.
    function buyTokens(uint256 listingId) public payable {
        TokenListing memory listing = tokenListings[listingId];
        if (!listing.active) revert ListingNotActive();
        if (msg.value < listing.price) revert InsufficientPayment();

        tokenListings[listingId].active = false;
        tokenContract.transferFrom(listing.seller, msg.sender, listing.amount);
        payable(listing.seller).transfer(listing.price);

        emit TokenSold(listingId, msg.sender, listing.amount, listing.price);

        if (msg.value > listing.price) {
            payable(msg.sender).transfer(msg.value - listing.price);
        }
    }

    /// @notice Cancels an NFT listing.
    /// @dev Only callable by the seller of an active listing.
    /// @param tokenId The ID of the NFT listing to cancel.
    function cancelNFTListing(uint256 tokenId) public {
        NFTListing memory listing = nftListings[tokenId];
        if (listing.seller != msg.sender) revert NotNFTOwner();
        if (!listing.active) revert ListingNotActive();
        nftListings[tokenId].active = false;
    }

    /// @notice Cancels an ERC-20 token listing.
    /// @dev Only callable by the seller of an active listing.
    /// @param listingId The ID of the token listing to cancel.
    function cancelTokenListing(uint256 listingId) public {
        TokenListing memory listing = tokenListings[listingId];
        if (listing.seller != msg.sender) revert NotNFTOwner();
        if (!listing.active) revert ListingNotActive();
        tokenListings[listingId].active = false;
    }
}