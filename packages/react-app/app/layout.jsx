
'use client';

import React, { useState } from 'react';
import Header from '../components/Header';
import Footer from '../components/Footer';
import '../styles/globals.css'; 

export default function RootLayout({ children }) {
  const [walletConnected, setWalletConnected] = useState(false);
  const [accountAddress, setAccountAddress] = useState('');

  // Simulate wallet connection
  const connectWallet = () => {
    const mockAddress = '0xAbC123DeF456GhI789JkL012MnOP345QrS678TuV9';
    setAccountAddress(mockAddress);
    setWalletConnected(true);
    console.log('Wallet connected:', mockAddress);
  };

  const disconnectWallet = () => {
    setAccountAddress('');
    setWalletConnected(false);
    console.log('Wallet disconnected.');
  };

  return (
    <html lang="en">
      {/* The <body> tag is rendered directly here */}
      <body className="min-h-screen bg-gray-100 font-inter antialiased flex flex-col">
        {/* REMOVE THE GOOGLE FONTS LINK FROM HERE if you put it in app/head.jsx */}

        <Header
          walletConnected={walletConnected}
          accountAddress={accountAddress}
          connectWallet={connectWallet}
          disconnectWallet={disconnectWallet}
        />

        <main className="flex-grow container mx-auto p-4">
          {/* Children are your page.jsx components */}
          {children}
        </main>

        <Footer />
      </body>
    </html>
  );
}