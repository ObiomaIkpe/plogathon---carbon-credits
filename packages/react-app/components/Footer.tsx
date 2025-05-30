import React from 'react';

function Footer() {
  return (
    <footer className="bg-gray-800 text-white p-6 mt-8 rounded-t-xl">
      <div className="container mx-auto text-center text-sm">
        <p className="mb-2">&copy; {new Date().getFullYear()} Carbon Credits. All rights reserved.</p>
        <p>Built with 🌱 Web3 for a greener future.</p> [cite: 6]
      </div>
    </footer>
  );
}

export default Footer;