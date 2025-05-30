import React from 'react';
import Link from 'next/link';
import FeatureCard from '../components/FeatureCard';

export default function HomePage() {
  return (
    <>
      {/* Hero Section */}
      <section className="bg-gradient-to-br from-green-50 to-emerald-100 py-16 px-4 text-center rounded-xl shadow-inner my-8 mx-auto max-w-4xl">
        <h2 className="text-5xl font-extrabold text-green-800 mb-6 leading-tight">
          Decentralized Carbon Credit & Offsetting Platform
        </h2> [cite: 1]
        <p className="text-xl text-gray-700 mb-8 max-w-2xl mx-auto">
          Leveraging Web3 for Transparent, Secure, and Scalable Carbon Markets.
        </p> [cite: 1]
        <Link href="/marketplace">
          <a className="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-8 rounded-full text-lg shadow-lg transform hover:scale-105 transition-all duration-300">
            Explore the Marketplace
          </a>
        </Link>
      </section>

      {/* Features Section */}
      <section className="py-12 px-4 bg-white rounded-xl shadow-lg my-8 mx-auto max-w-6xl">
        <h3 className="text-4xl font-bold text-center text-green-700 mb-10">Key Features</h3> [cite: 4]
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <FeatureCard
            icon="✅"
            title="ERC-721 NFTs"
            description="Unique credits tied to verified projects, ensuring distinct ownership and traceability."
          /> [cite: 4]
          <FeatureCard
            icon="💰"
            title="ERC-20 Tokens"
            description="Standardized credits for easy trading and broader market accessibility."
          /> [cite: 4]
          <FeatureCard
            icon="🔄"
            title="Conversion Mechanism"
            description="One-way NFT-to-token burning ensures no double counting and maintains supply integrity."
          /> [cite: 4]
          <FeatureCard
            icon="🛒"
            title="Decentralized Marketplace"
            description="Trade securely and transparently using cUSD, fostering a truly open market."
          /> [cite: 4]
          <FeatureCard
            icon="🔗"
            title="Oracle Integration"
            description="Verified off-chain data via Chainlink ensures the integrity and reliability of emission offsets."
          /> [cite: 4]
          <FeatureCard
            icon="📊"
            title="Transparency & Scalability"
            description="Immutable credit tracking on-chain and readiness for deployment on L2s like Polygon or Avalanche."
          />
        </div>
      </section>
    </>
  );
}