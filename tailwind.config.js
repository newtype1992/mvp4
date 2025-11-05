/**
 * Tailwind configuration wiring semantic color tokens to CSS variables.
 * Update the RGB tuples in globals.css to adjust themes or add new ones.
 */
const plugin = require('tailwindcss/plugin');

module.exports = {
  content: [
    './web/**/*.{html,js,ts,tsx}',
    './lib/**/*.{dart,html,js,ts,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        bg: 'rgb(var(--color-bg) / <alpha-value>)',
        surface: 'rgb(var(--color-surface) / <alpha-value>)',
        text: 'rgb(var(--color-text) / <alpha-value>)',
        subtext: 'rgb(var(--color-subtext) / <alpha-value>)',
        border: 'rgb(var(--color-border) / <alpha-value>)',
        cta: 'rgb(var(--color-cta) / <alpha-value>)',
        highlight: 'rgb(var(--color-highlight) / <alpha-value>)',
        support: 'rgb(var(--color-support) / <alpha-value>)',
        supportAccent: 'rgb(var(--color-support-accent) / <alpha-value>)',
      },
    },
  },
  plugins: [
    plugin(function ({ addVariant }) {
      addVariant('theme', '[data-theme="default"] &');
      addVariant('theme-dark', '[data-theme="dark"] &');
      addVariant('theme-vibrant', '[data-theme="vibrant"] &');
    }),
  ],
};
