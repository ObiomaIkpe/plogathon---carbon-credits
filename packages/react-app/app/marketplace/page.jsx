'use client';

import React, { useState } from 'react';

export default function MarketplacePage() {
  const walletConnected = true; 
  const [listings, setListings] = useState([
    { id: 1, type: 'NFT', item: 'Forest Reforestation NFT #004', price: '100 cUSD', status: 'Available' },
    { id: 2, type: 'Token', item: '500 CC Tokens', price: '50 cUSD', status: 'Available' },
    { id: 3, type: 'NFT', item: 'Wind Farm Project NFT #005', price: '150 cUSD', status: 'Available' },
  ]);
  const [message, setMessage] = useState('');

  const handleBuy = (id) => {
    // Simulate buying
    setListings(prev => prev.map(listing =>
      listing.id === id ? { ...listing, status: 'Sold (Mock)' } : listing
    ));
    setMessage(`Successfully bought item #${id}!`);
    setTimeout(() => setMessage(''), 3000); // Clear message after 3 seconds
  };

  return (
    <section className="py-12 px-4 bg-white rounded-xl shadow-lg my-8 mx-auto max-w-6xl">
      <h3 className="text-4xl font-bold text-center text-green-700 mb-8">Decentralized Marketplace</h3> 
      {walletConnected ? (
        <div className="text-center">
          <p className="text-lg text-gray-600 mb-6">
            Trade ERC-721 NFTs and ERC-20 Tokens securely using cUSD.
          </p>
          {message && (
            <p className="mb-4 text-sm font-medium text-green-700">{message}</p>
          )}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {listings.map(listing => (
              <div key={listing.id} className="bg-green-50 rounded-lg shadow-md p-5">
                <h4 className="text-xl font-semibold text-green-800 mb-2">{listing.item}</h4>
                <p className="text-gray-700 mb-1">Type: {listing.type}</p>
                <p className="text-gray-700 mb-3">Price: <span className="font-bold text-green-900">{listing.price}</span></p>
                <p className={`font-medium ${listing.status === 'Available' ? 'text-green-600' : 'text-red-500'}`}>
                  Status: {listing.status}
                </p>
                {listing.status === 'Available' && (
                  <button
                    onClick={() => handleBuy(listing.id)}
                    className="mt-4 bg-green-600 hover:bg-green-700 text-white text-sm py-2 px-4 rounded-full shadow-sm transition-all duration-300"
                  >
                    Buy
                  </button>
                )}
              </div>
            ))}
          </div>
          <button className="mt-8 bg-blue-500 hover:bg-blue-600 text-white font-bold py-3 px-6 rounded-full shadow-md transition-all duration-300 transform hover:scale-105">
            List New Item
          </button>
        </div>
      ) : (
        <p className="text-center text-gray-500 text-lg">
          Connect your wallet to access the marketplace.
        </p>
      )}
    </section>
  );
}