import React from 'react';

/**
 * HimoPayIcon — Standalone Mark Icon Component
 * 
 * @param {number} size - Icon dimensions in pixels (default: 40)
 * @param {string} orangeColor - Hex or CSS color for the left pillar & crossbar (default: '#EB5A2D')
 * @param {string} rightPillarColor - Hex or CSS color for the right pillar (default: '#FFFFFF')
 * @param {string} className - Additional CSS class names
 */
export const HimoPayIcon = ({
  size = 40,
  orangeColor = '#EB5A2D',
  rightPillarColor = '#FFFFFF',
  className = '',
  style = {},
}) => {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 100 100"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
      style={{ display: 'inline-block', verticalAlign: 'middle', flexShrink: 0, ...style }}
      aria-label="HimoPay Icon"
    >
      {/* Left Orange Pillar + Horizontal Crossbar */}
      <path
        d="M10 10H30V40H49V60H30V90H10V10Z"
        fill={orangeColor}
      />
      {/* Right Pillar with Semicircular Notch & Protruding Tab */}
      <path
        d="M49 10H69V40A10 10 0 0 1 69 60V90H49V60A10 10 0 0 1 49 40V10Z"
        fill={rightPillarColor}
      />
    </svg>
  );
};

/**
 * HimoPayLogo — Full Brand Logo Component (Icon + Wordmark)
 * 
 * @param {number} height - Total height of the logo in pixels (default: 44)
 * @param {'dark' | 'light'} variant - 'dark' for dark backgrounds (white text), 'light' for light backgrounds (charcoal text)
 * @param {boolean} iconOnly - When true, renders only the H logo mark without text
 * @param {string} orangeColor - Custom orange brand color (default: '#EB5A2D')
 * @param {string} textColor - Custom text & right-pillar color override
 * @param {string} className - Additional CSS class names
 */
export const HimoPayLogo = ({
  height = 44,
  variant = 'dark',
  iconOnly = false,
  orangeColor = '#EB5A2D',
  textColor,
  className = '',
  style = {},
}) => {
  const isLight = variant === 'light';
  const resolvedTextColor = textColor || (isLight ? '#161A22' : '#FFFFFF');
  const rightPillarColor = isLight ? '#161A22' : '#FFFFFF';

  if (iconOnly) {
    return (
      <HimoPayIcon
        size={height}
        orangeColor={orangeColor}
        rightPillarColor={rightPillarColor}
        className={className}
        style={style}
      />
    );
  }

  // Aspect ratio for full logo with wordmark is 350:100 (width = height * 3.5)
  const width = height * 3.5;

  return (
    <div
      className={className}
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: `${height * 0.28}px`,
        userSelect: 'none',
        ...style,
      }}
    >
      <HimoPayIcon
        size={height}
        orangeColor={orangeColor}
        rightPillarColor={rightPillarColor}
      />
      <span
        style={{
          fontFamily: "'Plus Jakarta Sans', 'Poppins', 'Inter', -apple-system, sans-serif",
          fontSize: `${height * 0.72}px`,
          fontWeight: 700,
          letterSpacing: '-0.02em',
          color: resolvedTextColor,
          lineHeight: 1,
          display: 'flex',
          alignItems: 'center',
        }}
      >
        HimoPay
      </span>
    </div>
  );
};

export default HimoPayLogo;
