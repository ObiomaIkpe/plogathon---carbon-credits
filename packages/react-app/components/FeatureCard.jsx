import React from 'react';

function FeatureCard({ icon, title, description }) {
  return (
    <div className="bg-green-50 p-6 rounded-lg shadow-md hover:shadow-xl transition-shadow duration-300 transform hover:-translate-y-1">
      <div className="text-5xl mb-4 text-center">{icon}</div>
      <h4 className="text-2xl font-semibold text-green-800 mb-3 text-center">{title}</h4>
      <p className="text-gray-600 text-center">{description}</p>
    </div>
  );
}

export default FeatureCard;