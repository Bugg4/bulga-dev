import { defineCollection } from "astro:content";
import { glob } from "astro/loaders";
import { z } from "astro/zod";

const posts = defineCollection({
  loader: glob({ pattern: "**/*.mdx", base: "./src/content/posts" }),
  schema: z.object({
    postNumber: z.number().int().positive(),
    slug: z.string().min(1),
    title: z.string().min(1),
    subtitle: z.string().min(1),
    author: z.string().min(1),
    publishedAt: z.coerce.date(),
    readTimeMinutes: z.number().int().positive(),
    tags: z.array(z.string()).default([]),
    draft: z.boolean().default(false),
  }),
});

export const collections = { posts };
