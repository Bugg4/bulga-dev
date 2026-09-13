import { defineConfig } from "astro/config";
import mdx from "@astrojs/mdx";
import react from "@astrojs/react";
import sitemap from "@astrojs/sitemap";

export default defineConfig({
  site: "https://me.bulga.dev",
  outDir: "./dist",
  output: "static",
  // Emit `blog/post/<slug>.html` files exactly, matching legacy Typst slugs
  // relocated under the /blog/ section.
  build: { format: "file" },
  trailingSlash: "never",
  redirects: {
    // Legacy blog.bulga.dev routes, preserved after the me.bulga.dev cutover.
    // Note: with `build.format: "file"`, Astro appends `.html` to redirect
    // sources ending in `.html`, so sources omit the suffix here. Generated
    // files are still `/post/<slug>.html` as before.
    "/post/post-001-hello-internet!":
      "/blog/post/post-001-hello-internet!.html",
    "/post/post-002-my-coding-setup":
      "/blog/post/post-002-my-coding-setup.html",
    "/post/post-003-is-a-faucet-intelligent":
      "/blog/post/post-003-is-a-faucet-intelligent.html",
  },
  integrations: [
    mdx(),
    react(),
    sitemap({
      // Sitemap derives page URLs without the `.html` suffix; restore it
      // so entries match the preserved public routes.
      serialize: (item) => {
        const match = item.url.match(/^(.*\/blog\/post\/[^/]+)(\/)?$/);
        if (match && !match[1].endsWith(".html")) {
          item.url = `${match[1]}.html`;
        }
        return item;
      },
    }),
  ],
});
