---
name: Luminous Fluidity
colors:
  surface: '#101415'
  surface-dim: '#101415'
  surface-bright: '#363a3b'
  surface-container-lowest: '#0b0f10'
  surface-container-low: '#191c1e'
  surface-container: '#1d2022'
  surface-container-high: '#272a2c'
  surface-container-highest: '#323537'
  on-surface: '#e0e3e5'
  on-surface-variant: '#b9cacb'
  inverse-surface: '#e0e3e5'
  inverse-on-surface: '#2d3133'
  outline: '#849495'
  outline-variant: '#3a494b'
  surface-tint: '#00dbe7'
  primary: '#e1fdff'
  on-primary: '#00363a'
  primary-container: '#00f2ff'
  on-primary-container: '#006a71'
  inverse-primary: '#00696f'
  secondary: '#adc6ff'
  on-secondary: '#002e69'
  secondary-container: '#4b8eff'
  on-secondary-container: '#00285c'
  tertiary: '#f6f7ff'
  on-tertiary: '#003061'
  tertiary-container: '#cadcff'
  on-tertiary-container: '#3c6096'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#74f5ff'
  primary-fixed-dim: '#00dbe7'
  on-primary-fixed: '#002022'
  on-primary-fixed-variant: '#004f54'
  secondary-fixed: '#d8e2ff'
  secondary-fixed-dim: '#adc6ff'
  on-secondary-fixed: '#001a41'
  on-secondary-fixed-variant: '#004493'
  tertiary-fixed: '#d5e3ff'
  tertiary-fixed-dim: '#a7c8ff'
  on-tertiary-fixed: '#001b3c'
  on-tertiary-fixed-variant: '#1f477b'
  background: '#101415'
  on-background: '#e0e3e5'
  surface-variant: '#323537'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.2'
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Metropolis
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Metropolis
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  label-md:
    fontFamily: Hanken Grotesk
    fontSize: 14px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 48px
  xl: 80px
  container-max: 1280px
  gutter: 24px
  margin-mobile: 16px
---

## Brand & Style

The design system is centered on the concept of **Luminous Fluidity**. It targets a modern, tech-savvy demographic that values transparency and weightlessness in their financial tools. By utilizing **Glassmorphism**, the UI creates a sense of depth and hierarchy without the heavy cognitive load of solid containers.

The visual style is defined by:
- **Translucency:** Every surface feels like etched glass, allowing the vibrant background to peek through.
- **Precision:** Ultra-thin borders and sharp typography ensure the interface remains professional and "fintech-grade" despite its ethereal aesthetic.
- **Atmospheric Depth:** Using background blurs (frosted glass) to indicate layers, making the app feel like a physical stack of light-refracting panels.

## Colors

This design system utilizes a **Dark Mode** foundation to maximize the glow of the glass effects. The palette is inspired by "Deep Ocean" environments, transitioning from near-black teals to vibrant cyans.

- **Primary Action:** A glowing Cyan (#00F2FF) used for high-importance triggers and the "Active Payer" state.
- **Surfaces:** Surfaces are not solid colors but rather 10-20% white overlays with a 24px backdrop-blur.
- **Semantic Accents:** Statuses use high-vibrancy colors—Emerald for successful transactions and Amber for pending—ensuring clear readability against the dark, blurred backgrounds.

## Typography

We use **Geist** for its technical precision and exceptional legibility at small sizes—critical for financial data.

- **Hierarchy:** Large display sizes are reserved for account balances and total spending.
- **Weight:** Medium and Semi-bold weights are used for list item titles to maintain contrast against blurred backgrounds.
- **Letter Spacing:** Headlines use slight negative tracking to feel tighter and more modern, while labels use expanded tracking for better scannability in dense data views.

## Layout & Spacing

This design system uses a **Fluid Mobile Grid** with a baseline 8px rhythm.

- **Safe Zones:** Content is inset by a 20px margin from the screen edges to prevent glass containers from feeling "trapped" by the bezel.
- **Vertical Rhythm:** Components like transaction cards use 12px gutters. Larger functional blocks (e.g., the monthly chart vs. the recent list) are separated by 32px of breathing room to maintain the "lightweight" brand promise.
- **Floating Logic:** The primary navigation and main CTA should be treated as floating elements, never touching the screen edges, further emphasizing the glass sheet metaphor.

## Elevation & Depth

In this design system, depth is achieved through **optical refraction** rather than traditional drop shadows.

1.  **Level 0 (Background):** The deep ocean gradient.
2.  **Level 1 (Default Surface):** 10% White background, 24px Backdrop Blur, 0.5px White border at 20% opacity.
3.  **Level 2 (Active/Floating):** 20% White background, 32px Backdrop Blur, 1px White border at 40% opacity. This level uses a subtle "Cyan Glow" (0px 8px 24px rgba(0, 242, 255, 0.15)) to indicate interactivity.
4.  **Level 3 (Modals/Overlays):** High-contrast glass with a darker scrim behind it to focus the user’s attention.

## Shapes

The shape language is consistently **Rounded (Level 2)** to evoke the smoothness of water and polished glass.

- **Cards & Containers:** Use 1rem (16px) corner radius.
- **Buttons & Chips:** Use 2rem (32px) or "pill" shapes to differentiate interactive elements from static content containers.
- **Inputs:** Follow the card radius (16px) to maintain a cohesive "block" structure in forms.

## Components

### Buttons
- **Primary:** Linear gradient (Cyan to Azure), 100% opacity, with a soft outer glow in the same color. Text is Deep Ocean (#003366) for maximum contrast.
- **Ghost:** Transparent background, 1px Cyan border, Cyan text.

### Expense Cards
- Glass background (15% white).
- Left-aligned icon in a soft-blue circle.
- Right-aligned amount in `headline-md`.
- 0.5px white border to define the edge against the background gradient.

### Input Fields
- Semi-transparent glass background (10% white).
- Active state: Border increases to 1.5px with a Cyan glow.
- Placeholder text: Soft gray at 50% opacity.

### Status Chips
- **Paid:** Pill shape, Emerald background at 20% opacity, solid Emerald text.
- **Pending:** Pill shape, Amber background at 20% opacity, solid Amber text.

### Progress Bars
- Track: Deep Ocean at 40% opacity.
- Fill: Glowing Cyan gradient.
