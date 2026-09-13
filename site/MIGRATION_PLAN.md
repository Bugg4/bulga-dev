# Blog Migration Plan

## Objective

Migrate the blog in `blog/` from the experimental Typst HTML pipeline to a
static Astro site using React, MDX, TypeScript, and Bun.

The result must preserve the existing content, visual identity, public URLs,
custom domain, and static-hosting behavior while making authoring and deployment
simpler.

## Fixed Decisions

- Use Astro as the static site generator.
- Use Bun as the package manager and command runner.
- Use TypeScript in strict mode.
- Store posts as MDX in an Astro content collection.
- Enable React through `@astrojs/react`.
- Use React only for components that benefit from JSX or interactivity. Do not
  hydrate components unless they require browser-side behavior.
- Keep the existing plain CSS visual language. Do not add Tailwind, a component
  library, CSS-in-JS, a CMS, or a server runtime.
- Produce a fully static `blog/dist/` directory suitable for GitHub Pages.
- Deploy with GitHub Actions rather than committing generated files to the
  `publish` branch.
- Preserve existing public post URLs exactly in this migration.
- Keep the legacy Typst sources and scripts until the new implementation has
  passed all checks. Do not delete uncommitted or untracked user files in this
  pass.

## Current State

Treat the current working tree as the source of truth, not only `HEAD`. It
contains uncommitted and untracked blog work.

Current source files:

- `src/index.typ`
- `src/blog-template.typ`
- `src/utils.typ`
- `src/posts/post-001.typ`
- `src/posts/post-002.typ`
- `src/posts/post-003.typ`
- `src/styles/blog.css`
- `src/shared/favicon.png`
- `src/CNAME`
- `dist.typ`
- `deploy.sh`
- `watch.sh`
- `serve.sh`

Current production domain:

- `https://blog.bulga.dev`

Published routes that must continue to build:

- `/`
- `/post/post-001-hello-internet!.html`
- `/post/post-002-my-coding-setup.html`
- `/post/post-003-is-a-faucet-intelligent.html`

The current index links to each post's root fragment (`#post-001`, etc.). Keep
those root IDs so existing fragment links continue to work.

## Scope

### Included

- Bun/Astro project setup inside `blog/`
- React and MDX integration
- Typed post metadata
- Conversion of all three posts from Typst to MDX
- Existing layout and CSS migration
- Generated post index
- Heading numbering and table of contents
- Syntax-highlighted code blocks
- RSS feed and sitemap
- Canonical and social metadata
- Existing custom domain and favicon
- GitHub Actions deployment
- Build, type, content, link, desktop, and mobile verification

### Excluded

- A visual redesign
- Editing or proofreading article prose
- A CMS, comments, search, analytics, authentication, or database
- Server-side rendering
- Client-side routing
- New social accounts or invented profile URLs
- Deleting the old Typst implementation before explicit approval

## Target File Layout

Use this as a guide. Keep components consolidated when splitting them would not
improve readability.

```text
blog/
|-- public/
|   |-- .nojekyll
|   |-- CNAME
|   `-- favicon.png
|-- src/
|   |-- components/
|   |   |-- SpeakerQuote.tsx
|   |   `-- TableOfContents.astro
|   |-- content/
|   |   `-- posts/
|   |       |-- post-001-hello-internet.mdx
|   |       |-- post-002-my-coding-setup.mdx
|   |       `-- post-003-is-a-faucet-intelligent.mdx
|   |-- layouts/
|   |   |-- BaseLayout.astro
|   |   `-- PostLayout.astro
|   |-- pages/
|   |   |-- post/
|   |   |   `-- [slug].html.astro
|   |   |-- index.astro
|   |   `-- rss.xml.ts
|   |-- styles/
|   |   `-- blog.css
|   |-- config.ts
|   `-- content.config.ts
|-- astro.config.ts
|-- package.json
|-- tsconfig.json
`-- bun.lock

.github/
`-- workflows/
    `-- deploy-blog.yml
```

## Implementation Steps

### 1. Protect the Existing Work

1. Run `git status --short` from the repository root and record which files
   were already modified or untracked.
2. Do not reset, restore, clean, or overwrite those files.
3. Use the current `src/posts/*.typ` files as the article source, including the
   untracked third post.
4. If Typst is available, build the current site into a temporary directory and
   use it as a visual and semantic reference. Do not overwrite `blog/dist/` just
   to capture the baseline.
5. Record desktop and narrow-mobile reference screenshots if the existing build
   can be served locally.

### 2. Initialize Astro With Bun

Create the Astro project directly in `blog/`; do not run a scaffold command
that could replace existing files.

Add current stable releases of these runtime dependencies with Bun:

- `astro`
- `react`
- `react-dom`
- `@astrojs/react`
- `@astrojs/mdx`
- `@astrojs/rss`
- `@astrojs/sitemap`

Add current stable releases of these development dependencies:

- `typescript`
- `@astrojs/check`
- `@types/react`
- `@types/react-dom`

Define at least these scripts in `package.json`:

```json
{
  "scripts": {
    "dev": "astro dev",
    "build": "astro build",
    "preview": "astro preview",
    "check": "astro check"
  }
}
```

Requirements:

- Commit `bun.lock` as the only package-manager lockfile.
- Configure Astro for static output.
- Set `site` to `https://blog.bulga.dev`.
- Do not set a repository base path because the custom domain is rooted at `/`.
- Enable the React, MDX, and sitemap integrations.
- Extend Astro's strict TypeScript configuration.
- Update `.gitignore` for Astro (`dist/`, `.astro/`, and dependencies) without
  removing unrelated existing entries unless they are demonstrably obsolete.

### 3. Define Site and Content Data

Create `src/config.ts` for site-wide constants so author and URL values are not
repeated across templates. Include:

- Site title
- Author: `Marco Bulgarelli`
- Canonical site URL: `https://blog.bulga.dev`
- GitHub URL: `https://github.com/Bugg4`

Do not invent a Twitter/X URL. Only render links with real destinations.

Create a `posts` content collection in `src/content.config.ts`. Validate at
least the following frontmatter fields:

- `postNumber`: positive integer
- `slug`: non-empty string used for the public route
- `title`: non-empty string
- `subtitle`: non-empty string
- `author`: non-empty string
- `publishedAt`: date
- `readTimeMinutes`: positive integer
- `tags`: array of strings
- `draft`: boolean defaulting to `false`

Keep the explicit reading-time values from the existing posts rather than
silently changing published metadata. Posts must be sorted newest first by
`publishedAt`, with `postNumber` as a deterministic tie-breaker. Filter drafts
out of production index, route generation, RSS, and sitemap output.

Use these route slugs:

- `post-001-hello-internet!`
- `post-002-my-coding-setup`
- `post-003-is-a-faucet-intelligent`

### 4. Build the Layout

Implement the reusable document shell in Astro, not React. Static structure
does not need a hydrated application.

`BaseLayout.astro` must provide:

- Valid HTML5 output with `lang="en"`
- UTF-8 and responsive viewport metadata
- Page title and description
- Canonical URL
- Favicon
- Open Graph title, description, type, and URL
- A keyboard-accessible body structure
- Shared navigation and footer
- The existing `Home` and `cd ..` visual language, but replace `href="#"` with
  either a real destination or a non-link element
- An RSS link in both document metadata and the visible footer
- A GitHub link using the known profile URL
- A dynamic copyright year rather than a hard-coded `2026`

`PostLayout.astro` must provide:

- `<article>` semantics
- One page-level `<h1>` containing title and subtitle
- Author, publication date, reading time, and tags
- Root post ID formatted as `post-NNN`
- A table of contents generated from rendered MDX headings
- A content container used to scope article styles and heading counters

Avoid malformed nested lists from the current generated HTML. The metadata list
and tags list must be valid siblings or nested list items.

### 5. Preserve Heading Behavior

The Typst source uses heading levels relative to the article title:

- Typst `=` becomes MDX `##`
- Typst `==` becomes MDX `###`
- Typst `===` becomes MDX `####`

Astro's generated heading slugs may replace the old `loc-N` heading fragments.
Preserve the root `#post-NNN` fragments exactly. Also preserve `loc-N` heading
IDs if this can be done without polluting every article with bespoke JSX;
otherwise document this one compatibility difference in the implementation
summary.

Generate visible hierarchical numbers for article headings and matching labels
in the table of contents. CSS counters are preferred for article headings. The
table-of-contents component may compute labels from heading depth. It must
support the heading nesting currently used by all three posts and produce valid
nested lists.

Do not number the table of contents' own `Contents` heading.

### 6. Migrate the Styling

Start from the current working-tree version of `src/styles/blog.css`; it has
uncommitted user changes. Move or adapt it rather than replacing it with a new
theme.

Preserve:

- Black background
- Cyan/fuchsia gradient title
- Monospace metadata and navigation
- Existing typography scale and approximately 48rem reading width
- Cyan links, fuchsia inline code, and bordered code blocks
- Yellow quotes and green/yellow speaker quotes
- Existing spacing and responsive feel

Improve only where required for correctness:

- Scope broad selectors to avoid styling unrelated page elements.
- Keep focus indicators visible for keyboard users.
- Ensure heading anchors are not hidden by viewport positioning.
- Ensure long code blocks scroll horizontally.
- Ensure text and metadata fit at approximately 360 CSS pixels wide.
- Respect `prefers-reduced-motion` if any motion is introduced.
- Do not introduce JavaScript for styling behavior that CSS can handle.

### 7. Convert the Three Posts to MDX

Convert from the Typst source files, using generated HTML only as a rendering
reference. Preserve the author's text, capitalization, spelling, links, code,
list structure, and deliberate line breaks. This task is a format migration,
not a copy-edit.

Map constructs as follows:

| Typst | MDX/HTML |
| --- | --- |
| `#link(url)[label]` | `[label](url)` |
| `*text*` | `**text**` |
| `_text_` | `_text_` |
| backtick code | backtick code |
| fenced code | fenced code with the same language |
| `#quote[...]` | semantic quote markup with the existing yellow style |
| `#Y[...]` | `SpeakerQuote` with the yellow variant |
| `#G[...]` | `SpeakerQuote` with the green variant |
| Typst table | semantic HTML table in MDX |
| explicit Typst line break | `<br />` only where the rendered break is intentional |

Implement `SpeakerQuote.tsx` as the initial React component. It should:

- Accept typed `children` and a `speaker` or `variant` prop.
- Render semantic inline quote markup.
- Produce the existing yellow and green classes.
- Render to static HTML with no `client:*` directive and therefore ship no
  browser JavaScript.

Check each converted post independently:

- Post 001: preserve all long fenced examples, the DNS table, external links,
  special inline spans, lists, and heading hierarchy.
- Post 002: preserve nested sections, external links, em dash text, and all MCP
  descriptions.
- Post 003: preserve `Y` and `G` speaker distinctions, formulas, lists, links,
  and nested headings.

Do not carry Typst template imports or implementation metadata into article
body text except where they are deliberately shown as code in Post 001.

### 8. Implement Routes and Generated Pages

Create `src/pages/index.astro` from the content collection. It must:

- List all non-draft posts newest first.
- Display the zero-padded post number, title, subtitle, date, and tags.
- Link to the exact preserved `.html` routes.
- Avoid hard-coded imports for individual posts.

Create `src/pages/post/[slug].html.astro` using `getStaticPaths`. It must emit
exactly one page per non-draft post and keep the existing route filenames,
including the exclamation mark in Post 001's filename.

Create `src/pages/rss.xml.ts` with `@astrojs/rss`. Include title, subtitle or
description, publication date, tags where supported, and canonical post URL.
The RSS endpoint must not include drafts.

Use the sitemap integration and ensure generated sitemap URLs use
`https://blog.bulga.dev` rather than the GitHub repository path.

Copy these static files without changing their data:

- `src/shared/favicon.png` to `public/favicon.png`
- `src/CNAME` to `public/CNAME`

Add `public/.nojekyll` so GitHub Pages serves the generated files directly.

### 9. Add GitHub Pages Deployment

Add `.github/workflows/deploy-blog.yml` at the repository root because `.github`
is repository-scoped, while the application lives under `blog/`.

The workflow must:

- Trigger on pushes to the repository's default branch when `blog/**` or the
  workflow changes.
- Support `workflow_dispatch`.
- Use the current stable major versions of official GitHub actions, pinned to a
  major tag rather than `main`.
- Set up Bun with the official `oven-sh/setup-bun` action.
- Run from `blog/` where appropriate.
- Run `bun install --frozen-lockfile`.
- Run `bun run check`.
- Run `bun run build`.
- Upload only `blog/dist/` with `actions/upload-pages-artifact`.
- Deploy with `actions/deploy-pages`.
- Grant only `contents: read`, `pages: write`, and `id-token: write` permissions.
- Use the `github-pages` environment and expose the deployment URL.
- Prevent overlapping deployments with an appropriate concurrency group.

Repository setup outside the codebase remains required: GitHub Pages must be
changed from "Deploy from a branch" to "GitHub Actions" after the workflow is
merged. Do not push, alter repository settings, or delete the `publish` branch
unless explicitly requested.

### 10. Verify the Migration

Run from `blog/`:

```sh
bun install --frozen-lockfile
bun run check
bun run build
```

Inspect the build and confirm that these files exist:

```text
dist/index.html
dist/post/post-001-hello-internet!.html
dist/post/post-002-my-coding-setup.html
dist/post/post-003-is-a-faucet-intelligent.html
dist/rss.xml
dist/CNAME
dist/.nojekyll
```

Serve the production build locally and verify with browser tooling at a desktop
viewport and a viewport approximately 360 pixels wide.

For every page, verify:

- No browser console errors
- No failed local asset requests
- Valid internal navigation
- Visible keyboard focus
- Correct title, subtitle, metadata, and tags
- Readable prose and horizontally scrollable code blocks
- Correct heading hierarchy and table-of-contents links
- No content hidden or overflowing on mobile
- Canonical URLs point to `https://blog.bulga.dev`

Across the site, verify:

- All three posts appear once on the index in newest-first order.
- All current external article links were carried over.
- RSS contains all three posts and no drafts.
- Sitemap contains the homepage and all three post routes.
- The generated `CNAME` contains exactly `blog.bulga.dev`.
- No client-side JavaScript is emitted solely for static React components.
- A direct request to each preserved `.html` route succeeds.

Compare representative sections of each new page with the current generated
HTML or baseline screenshots. Pay particular attention to Post 001's code
blocks and table, Post 002's nested outline, and Post 003's colored speaker
quotes.

### 11. Finish Without Destroying Legacy Work

Do not remove the Typst files, shell scripts, existing generated output, or the
`publish` branch during this implementation pass. Some are currently modified
or untracked and must not be discarded implicitly.

At completion:

1. Show `git status --short` and a focused diff of the migration.
2. Report all commands run and their outcomes.
3. Report any content or URL parity differences explicitly.
4. Identify the old files that are now unused, but leave their deletion for a
   separately approved cleanup after the Astro deployment is confirmed live.
5. Do not commit or push unless explicitly requested.

## Acceptance Criteria

The migration is complete when all of the following are true:

- `bun run check` succeeds.
- `bun run build` succeeds from a clean dependency install.
- The output is a static site and requires no Bun process in production.
- The homepage and all three preserved post URLs render successfully.
- All three articles retain their content, metadata, links, code blocks, lists,
  and intentional custom quote styling.
- The index, table of contents, RSS feed, and sitemap are generated from the
  content collection rather than maintained by hand.
- The site remains usable on desktop, mobile, and keyboard navigation.
- The favicon and `blog.bulga.dev` custom domain file are present in the build.
- The GitHub Actions workflow builds the app under `blog/` and uploads only the
  generated site.
- Existing user work has not been reset, overwritten, or deleted.
