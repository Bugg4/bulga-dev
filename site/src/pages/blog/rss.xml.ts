import { getCollection } from "astro:content";
import rss from "@astrojs/rss";
import { site } from "../../config";
import type { APIContext } from "astro";

const pad = (n: number) => String(n).padStart(3, "0");

export async function GET(context: APIContext) {
  const posts = (await getCollection("posts", ({ data }) => !data.draft)).sort(
    (a, b) =>
      b.data.publishedAt.getTime() - a.data.publishedAt.getTime() ||
      b.data.postNumber - a.data.postNumber,
  );
  return rss({
    title: `${site.title} — Blog`,
    description: site.description,
    site: context.site ?? site.url,
    items: posts.map((post) => ({
      title: post.data.title,
      description: post.data.subtitle,
      pubDate: post.data.publishedAt,
      categories: post.data.tags,
      link: `/blog/post/${post.data.slug}.html#post-${pad(post.data.postNumber)}`,
    })),
  });
}
