# Web Development

Build lean, maintainable browser software. Treat HTML, CSS, and browser APIs as
the platform; add framework and package weight only when it earns its keep.

## Defaults

- Existing project stack wins.
- New small SPA default: Vite, Preact, TypeScript.
- Styling: vanilla CSS or CSS Modules. Tailwind only if already present.
- State: local state or Preact signals. Avoid global stores unless already used.
- Fetch: native `fetch` with a thin typed wrapper. No Axios by default.

## Quality

- Semantic HTML and keyboard accessibility are baseline requirements.
- Keep components small and props explicit.
- Prefer Web APIs over dependencies.
- Avoid barrel files.
- Keep route and heavy component loading split when it matters.
- Mobile-first CSS with stable dimensions for fixed-format controls.

## Verification

- Use Vitest for unit/component tests when present.
- Use Playwright for user-flow or visual-risk changes when warranted.
- For UI work, check small and desktop viewports before calling it done.

## Rust Backend Fit

- Mirror Rust API contracts with typed TypeScript boundaries.
- Use Vite proxy for dev API calls, not CORS workarounds.
- Build static assets that Rust can serve or embed.

