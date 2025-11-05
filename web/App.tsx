import { useEffect, useMemo, useState } from 'react';
import './styles/globals.css';

type ThemeName = 'default' | 'dark' | 'vibrant';

const themes: ThemeName[] = ['default', 'dark', 'vibrant'];

export default function App() {
  const [themeIndex, setThemeIndex] = useState(0);

  const theme = useMemo(() => themes[themeIndex], [themeIndex]);

  useEffect(() => {
    const root = document.documentElement;
    root.setAttribute('data-theme', theme);
    return () => {
      root.removeAttribute('data-theme');
    };
  }, [theme]);

  const cycleTheme = () => {
    setThemeIndex((index) => (index + 1) % themes.length);
  };

  return (
    <div className="min-h-screen bg-bg text-text flex flex-col items-center justify-center gap-10">
      <header className="text-center space-y-4">
        <span className="inline-flex items-center gap-2 rounded-full bg-surface px-4 py-1 text-sm border border-border">
          <span className="h-2 w-2 rounded-full bg-highlight" aria-hidden />
          <span className="font-medium uppercase tracking-wide text-subtext">
            Current theme
          </span>
          <span className="font-semibold text-text">{theme}</span>
        </span>
        <h1 className="text-4xl font-bold text-text">
          Build once, theme everywhere.
        </h1>
        <p className="max-w-xl text-lg text-subtext">
          Semantic Tailwind tokens allow you to drop in new palettes by only updating the
          RGB tuples inside <code>globals.css</code>.
        </p>
      </header>

      <div className="flex items-center gap-4">
        <button type="button" onClick={cycleTheme}>
          Switch theme
        </button>
        <div className="flex gap-2 text-sm text-subtext">
          {themes.map((name) => (
            <span
              key={name}
              className={`inline-flex items-center gap-2 rounded-lg border border-border bg-surface px-3 py-2 ${
                name === theme ? 'shadow-lg text-text' : ''
              }`}
            >
              <span
                className={`h-3 w-3 rounded-full ${
                  name === 'default'
                    ? 'bg-cta'
                    : name === 'dark'
                    ? 'bg-highlight'
                    : 'bg-support'
                }`}
                aria-hidden
              />
              {name}
            </span>
          ))}
        </div>
      </div>

      <section className="grid grid-cols-1 gap-4 md:grid-cols-3 w-full max-w-4xl">
        <article className="rounded-2xl border border-border bg-surface p-6 shadow-sm">
          <h2 className="text-xl font-semibold text-text">CTA Example</h2>
          <p className="text-subtext mt-2">
            CTA buttons reuse <code>bg-cta</code> and <code>text-bg</code> utilities to stay legible.
          </p>
          <button type="button" className="mt-4 w-full">
            Get started
          </button>
        </article>

        <article className="rounded-2xl border border-border bg-surface p-6 shadow-sm">
          <h2 className="text-xl font-semibold text-text">Highlight Card</h2>
          <p className="text-subtext mt-2">
            Use <code>text-highlight</code> and <code>bg-support</code> to accent key metrics.
          </p>
          <div className="mt-4 rounded-xl bg-support/20 p-4 text-highlight">
            128% growth vs last month
          </div>
        </article>

        <article className="rounded-2xl border border-border bg-surface p-6 shadow-sm">
          <h2 className="text-xl font-semibold text-text">Add palettes fast</h2>
          <p className="text-subtext mt-2">
            Duplicate a <code>[data-theme]</code> block in <code>globals.css</code>, adjust the RGB
            tuples, and the same semantic classes instantly adopt the new look.
          </p>
          <div className="mt-4 flex gap-3">
            <span className="h-8 w-8 rounded-full bg-cta" aria-hidden />
            <span className="h-8 w-8 rounded-full bg-highlight" aria-hidden />
            <span className="h-8 w-8 rounded-full bg-support" aria-hidden />
          </div>
        </article>
      </section>
    </div>
  );
}
