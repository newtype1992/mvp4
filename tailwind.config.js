/**
 * Tailwind configuration wiring semantic color tokens to CSS variables.
 * This file mirrors the CDN configuration used in web/index.html so teams
 * can drop it into a standard Tailwind build if desired.
 */
module.exports = {
  content: ['./web/**/*.{html,js}'],
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
      boxShadow: {
        focus: '0 0 0 3px rgb(var(--color-highlight) / 0.35)',
      },
    },
  },
};
