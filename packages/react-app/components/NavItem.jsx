// This is a client component as it uses the usePathname hook.
'use client';

import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';

function NavItem({ href, label }) {
  const pathname = usePathname();
  // Determine if the current path matches the link's href.
  // Special handling for the root path ('/')
  const isActive = pathname === href || (href === '/' && pathname === '/');

  return (
    <Link href={href} passHref> {/* passHref is often used with custom <a> children */}
      {/*
        The <a> tag should be the direct and only child of Link
        if you are explicitly providing it. Removed the extra <a> tag.
      */}
      
        className={`px-3 py-2 rounded-md text-sm font-medium transition-all duration-200 ${
          isActive
            ? 'bg-green-800 text-white shadow-inner'
            : 'text-green-100 hover:bg-green-700 hover:text-white'
        }`}
    
        {label}
    
    </Link>
  );
}

export default NavItem;