// This is a client component as it uses the useRouter hook.
'use client';

import React from 'react';
import { usePathname } from 'next/navigation'; // Import usePathname for App Router
import NavItem from './NavItem';

function Header({ walletConnected, accountAddress, connectWallet, disconnectWallet }) {
  const pathname = usePathname(); // Get current path

  return (
    <header className="bg-gradient-to-r from-green-600 to-emerald-700 text-white p-4 shadow-lg rounded-b-xl">
      <div className="container mx-auto flex justify-between items-center flex-wrap">
        <h1 className="text-3xl font-bold text-white mb-2 md:mb-0">
          🌱 Carbon Credits
        </h1>
        <nav className="flex space-x-4 flex-grow justify-center md:flex-grow-0">
          <NavItem href="/" label="Home" currentPath={pathname} />
          <NavItem href="/nfts" label="NFTs" currentPath={pathname} />
          <NavItem href="/tokens" label="Tokens" currentPath={pathname} />
          <NavItem href="/marketplace" label="Marketplace" currentPath={pathname} />
        </nav>
        <div className="mt-2 md:mt-0">
          {walletConnected ? (
            <div className="flex items-center bg-green-800 px-4 py-2 rounded-full shadow-md">
              <span className="text-sm mr-2 hidden sm:inline">Connected:</span>
              <span className="font-mono text-xs sm:text-sm truncate max-w-[120px] sm:max-w-none">
                {accountAddress.substring(0, 6)}...{accountAddress.substring(accountAddress.length - 4)}
              </span>
              <button
                onClick={disconnectWallet}
                className="ml-3 text-red-300 hover:text-red-100 transition-colors duration-200"
                aria-label="Disconnect Wallet"
              >
                <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
                </svg>
              </button>
            </div>
          ) : (
            <button
              onClick={connectWallet}
              className="bg-green-800 hover:bg-green-900 text-white font-semibold py-2 px-4 rounded-full shadow-md transition-all duration-300 transform hover:scale-105"
            >
              Connect Wallet
            </button>
          )}
        </div>
      </div>
    </header>
  );
}

export default Header;