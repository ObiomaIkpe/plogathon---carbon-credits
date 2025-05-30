// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "./CarbonCreditNFT.sol";
import "./CarbonCreditToken.sol";

contract CarbonCreditConverter {
    CarbonCreditNFT public immutable nftContract;
    CarbonCreditToken public immutable tokenContract;

    // Custom errors
    error NotNFTOwner();
    error NotApproved();
    error InvalidCarbonAmount();

    // Event
    event ConvertedToTokens(address indexed user, uint256 indexed tokenId, uint256 carbonTons);

    constructor(address _nftContract, address _tokenContract) {
        nftContract = CarbonCreditNFT(_nftContract);
        tokenContract = CarbonCreditToken(_tokenContract);
    }

    function convertNFTtoTokens(uint256 tokenId) public {
        if (nftContract.ownerOf(tokenId) != msg.sender) revert NotNFTOwner();
        if (!nftContract.isApprovedForAll(msg.sender, address(this)) && nftContract.getApproved(tokenId) != address(this)) 
            revert NotApproved();

        uint256 carbonTons = nftContract.carbonAmount(tokenId);
        if (carbonTons == 0) revert InvalidCarbonAmount();

        nftContract.burn(tokenId); // Burn NFT to prevent double counting
        tokenContract.mint(msg.sender, carbonTons); // Mint equivalent ERC-20 tokens

        emit ConvertedToTokens(msg.sender, tokenId, carbonTons);
    }
}