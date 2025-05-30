import React from 'react';

function NFTCard({ id, project, offset, image }) {
  return (
    <div className="bg-green-100 rounded-lg shadow-md p-4 flex flex-col items-center">
      <img
        src={image}
        alt={`NFT ${id}`}
        className="rounded-md mb-4 w-full h-40 object-cover"
        onError={(e) => { e.target.onerror = null; e.target.src="https://placehold.co/300x200/a7f3d0/065f46?text=NFT+Image+Error"; }}
      />
      <h4 className="text-xl font-semibold text-green-800 mb-2">{project}</h4>
      <p className="text-gray-700 text-sm">ID: #{id}</p>
      <p className="text-gray-700 text-sm">Offset: {offset}</p>
      <button className="mt-4 bg-green-600 hover:bg-green-700 text-white text-sm py-2 px-4 rounded-full shadow-sm transition-all duration-300">
        View Details (Mock)
      </button>
    </div>
  );
}

export default NFTCard;