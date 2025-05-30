'use client';

import React from 'react';
import NFTCard from '../../components/NFTCard';

export default function NFTsPage({ walletConnected }) {
  return (
    <section className="py-12 px-4 bg-white rounded-xl shadow-lg my-8 mx-auto max-w-4xl">
      <h3 className="text-4xl font-bold text-center text-green-700 mb-8">Your Carbon Credit NFTs</h3>
      {walletConnected ? (
        <div className="text-center">
          <p className="text-lg text-gray-600 mb-6">
            Here you would see your unique ERC-721 Carbon Credit NFTs, each representing a verified project.
          </p>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <NFTCard
              id="001"
              project="Forest Reforestation - Amazon"
              offset="500 tons CO2"
              image="https://placehold.co/300x200/a7f3d0/065f46?text=NFT+001"
            />
            <NFTCard
              id="002"
              project="Renewable Energy - Solar Farm"
              offset="1200 tons CO2"
              image="https://placehold.co/300x200/a7f3d0/065f46?text=NFT+002"
            />
             <NFTCard
              id="003"
              project="Ocean Cleanup Initiative"
              offset="750 tons CO2"
              image="https://placehold.co/300x200/a7f3d0/065f46?text=NFT+003"
            />
          </div>
          <button className="mt-8 bg-green-500 hover:bg-green-600 text-white font-bold py-3 px-6 rounded-full shadow-md transition-all duration-300 transform hover:scale-105">
            Mint New NFT
          </button>
        </div>
      ) : (
        <p className="text-center text-gray-500 text-lg">
          Connect your wallet to view your Carbon Credit NFTs.
        </p>
      )}
    </section>
  );
}