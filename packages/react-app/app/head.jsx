// app/head.jsx (This file is a Server Component by default)

export const metadata = {
  title: 'Carbon Credits DApp',
  description: 'Decentralized Carbon Credit & Offsetting Platform',
};

export default function Head() {
  return (
    <>
      {/* You can also place other head elements directly here if needed,
          though `metadata` export is preferred for most common tags. */}
      <link rel="icon" href="/favicon.ico" />
      {/* Google Fonts link can also go here for consistency with Head elements */}
      <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    </>
  );
}