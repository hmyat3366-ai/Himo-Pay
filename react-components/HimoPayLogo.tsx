import React from 'react';

export interface HimoPayIconProps extends React.SVGProps<SVGSVGElement> {
  size?: number;
  orangeColor?: string;
  rightPillarColor?: string;
}

/**
 * HimoPayIcon — Standalone Mark Icon Component (TypeScript)
 */
export const HimoPayIcon: React.FC<HimoPayIconProps> = ({
  size = 40,
  orangeColor = '#EB5A2D',
  rightPillarColor = '#FFFFFF',
  className = '',
  style = {},
  ...rest
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
      {...rest}
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

export interface HimoPayLogoProps extends React.HTMLAttributes<HTMLDivElement> {
  height?: number;
  variant?: 'dark' | 'light';
  iconOnly?: boolean;
  orangeColor?: string;
  textColor?: string;
}

/**
 * HimoPayLogo — Full Brand Logo Component (Icon + Wordmark)
 */
export const HimoPayLogo: React.FC<HimoPayLogoProps> = ({
  height = 44,
  variant = 'dark',
  iconOnly = false,
  orangeColor = '#EB5A2D',
  textColor,
  className = '',
  style = {},
  ...rest
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
      {...rest}
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
