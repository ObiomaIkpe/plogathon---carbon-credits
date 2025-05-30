// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "./CarbonCreditNFT.sol";
import "./CarbonCreditToken.sol";

contract CarbonCreditMarketplace {
    CarbonCreditNFT public immutable nftContract;
    CarbonCreditToken public immutable tokenContract;

    struct NFTListing {
        uint256 tokenId;
        address seller;
        uint256 price; // Price in wei
        bool active;
    }

    struct TokenListing {
        address seller;
        uint256 amount; // Amount of ERC-20 tokens
        uint256 price; // Price in wei
        bool active;
    }

    mapping(uint256 => NFTListing) public nftListings;
    mapping(uint256 => TokenListing) public tokenListings;
    uint256 public nftListingCount;
    uint256 public tokenListingCount;

    // Custom errors
    error NotNFTOwner();
    error NotApproved();
    error ListingNotActive();
    error InsufficientPayment();
    error InsufficientTokenBalance();
    error InsufficientTokenAllowance();
    error SellerNoLongerOwns();

    // Events
    event NFTListed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event TokenListed(uint256 indexed listingId, address indexed seller, uint256 amount, uint256 price);
    event NFTSold(uint256 indexed tokenId, address indexed buyer, uint256 price);
    event TokenSold(uint256 indexed listingId, address indexed buyer, uint256 amount, uint256 price);

    constructor(address _nftContract, address _tokenContract) {
        nftContract = CarbonCreditNFT(_nftContract);
        tokenContract = CarbonCreditToken(_tokenContract);
    }

    function listNFT(uint256 tokenId, uint256 price) public {
        if (nftContract.ownerOf(tokenId) != msg.sender) revert NotNFTOwner();
        if (nftContract.getApproved(tokenId) != address(this)) revert NotApproved();

        nftListings[tokenId] = NFTListing(tokenId, msg.sender, price, true);
        nftListingCount++;
        emit NFTListed(tokenId, msg.sender, price);
    }

    function listTokens(uint256 amount, uint256 price) public {
        if (tokenContract.balanceOf(msg.sender) < amount) revert InsufficientTokenBalance();
        if (tokenContract.allowance(msg.sender, address(this)) < amount) revert InsufficientTokenAllowance();

        tokenListings[tokenListingCount] = TokenListing(msg.sender, amount, price, true);
        tokenListingCount++;
        emit TokenListed(tokenListingCount - 1, msg.sender, amount, price);
    }

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

    function cancelNFTListing(uint256 tokenId) public {
        NFTListing memory listing = nftListings[tokenId];
        if (listing.seller != msg.sender) revert NotNFTOwner();
        if (!listing.active) revert ListingNotActive();
        nftListings[tokenId].active = false;
    }

    function cancelTokenListing(uint256 listingId) public {
        TokenListing memory listing = tokenListings[listingId];
        if (listing.seller != msg.sender) revert NotNFTOwner();
        if (!listing.active) revert ListingNotActive();
        tokenListings[listingId].active = false;
    }
}