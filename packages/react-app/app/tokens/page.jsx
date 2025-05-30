// This is a client component as it uses useState.
'use client';

import React, { useState } from 'react';

export default function TokensPage({ walletConnected }) {
  const [tokenBalance, setTokenBalance] = useState(1000); // Mock balance
  const [nftToConvert, setNftToConvert] = useState('');
  const [conversionAmount, setConversionAmount] = useState(0);
  const [message, setMessage] = useState('');

  const handleConvertNFT = () => {
    if (!nftToConvert) {
      setMessage('Please enter an NFT ID to convert.');
      return;
    }
    if (conversionAmount <= 0) {
      setMessage('Conversion amount must be greater than zero.');
      return;
    }
    // Simulate conversion
    setTokenBalance(prev => prev + conversionAmount);
    setMessage(`Successfully converted NFT #${nftToConvert} to ${conversionAmount} CC Tokens!`);
    setNftToConvert('');
    setConversionAmount(0);
    setTimeout(() => setMessage(''), 3000); // Clear message after 3 seconds
  };

  return (
    <section className="py-12 px-4 bg-white rounded-xl shadow-lg my-8 mx-auto max-w-4xl">
      <h3 className="text-4xl font-bold text-center text-green-700 mb-8">Carbon Credit Tokens (ERC-20)</h3> 
      {walletConnected ? (
        <div className="text-center">
          <p className="text-2xl text-green-800 font-semibold mb-6">
            Your Balance: <span className="font-bold">{tokenBalance}</span> CC Tokens
          </p>

          <div className="bg-green-50 p-6 rounded-lg shadow-md mb-8">
            <h4 className="text-2xl font-semibold text-green-800 mb-4">Convert NFT to Tokens</h4>
            <p className="text-gray-600 mb-4">
              Burn your project-specific NFTs to receive standardized ERC-20 tokens. 
            </p>
            <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
              <input
                type="text"
                placeholder="Enter NFT ID (e.g., 001)"
                className="p-3 border border-gray-300 rounded-md w-full sm:w-auto focus:ring-green-500 focus:border-green-500"
                value={nftToConvert}
                onChange={(e) => setNftToConvert(e.target.value)}
              />
               <input
                type="number"
                placeholder="Amount of tokens"
                className="p-3 border border-gray-300 rounded-md w-full sm:w-auto focus:ring-green-500 focus:border-green-500"
                value={conversionAmount}
                onChange={(e) => setConversionAmount(Number(e.target.value))}
              />
              <button
                onClick={handleConvertNFT}
                className="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-full shadow-md transition-all duration-300 transform hover:scale-105 w-full sm:w-auto"
              >
                Convert (Mock)
              </button>
            </div>
            {message && (
              <p className="mt-4 text-sm font-medium text-green-700">{message}</p>
            )}
          </div>

          <div className="flex justify-center gap-4">
            <button className="bg-blue-500 hover:bg-blue-600 text-white font-bold py-3 px-6 rounded-full shadow-md transition-all duration-300 transform hover:scale-105">
              Buy Tokens (Mock)
            </button>
            <button className="bg-red-500 hover:bg-red-600 text-white font-bold py-3 px-6 rounded-full shadow-md transition-all duration-300 transform hover:scale-105">
              Sell Tokens (Mock)
            </button>
          </div>
        </div>
      ) : (
        <p className="text-center text-gray-500 text-lg">
          Connect your wallet to manage your Carbon Credit Tokens.
        </p>
      )}
    </section>
  );
}