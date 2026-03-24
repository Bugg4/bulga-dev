#import "utils.typ": post_id, slugify

// ==========================================
// Globals
// ==========================================

#let styles = (
  // https://ydx-typst.netlify.app/reference/foundations/path/#path-type
  blog: "/styles/blog.css",
)

#let shared = (
  favicon: "shared/favicon.png",
)

#let tags = (
  meta: "meta",
  typst: "typst",
)

#let page_kind = (
  post: (route: "post/"),
  index: (route: "/"),
)

// ==========================================
// Layout Components
// ==========================================

#let blog_head(title, stylesheet) = html.head(
  html.meta(charset: "utf-8")
    + html.meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
    + html.title(title)
    // NOTE: favicon currently not working because of broken head, see: https://github.com/typst/typst/issues/7974
    + html.link(rel: "icon", type: "image/x-icon", href: shared.favicon)
    + html.link(rel: "stylesheet", href: stylesheet),
)

#let blog_nav() = html.nav(
  html.a(
    href: "/",
    class: "nav-brand",
    "Home",
  )
    + html.a(
      href: "#",
      class: "nav-link",
      "cd ..",
    ),
)

#let blog_header(title, subtitle, author, date_published, read_time, tags) = html.header(
  html.h1(
    html.span(class: "blog-title gradient", title) + html.br() + html.span(class: "blog-subtitle", subtitle),
  )
    + html.div(
      class: "blog-metadata",
      html.ul(
        html.li(class: "author", author)
          + html.li(class: "date-published", date_published.display())
          + html.li(class: "read-time", read_time)
          + html.ul(
            class: "tags",
            tags.map(t => html.li(class: "tag", t)).join(),
          ),
      ),
    ),
)

#let blog_footer(author, year) = html.elem(
  "footer",
  html.elem("p", attrs: (class: "footer-copy"), "© " + str(year) + " " + author + ". All rights reserved.")
    + html.elem(
      "ul",
      attrs: (class: "footer-links"),
      html.li(html.elem("a", attrs: (href: "#", "aria-label": "GitHub")))
        + html.li(html.elem("a", attrs: (href: "#", "aria-label": "Twitter")))
        + html.li(html.elem("a", attrs: (href: "#", "aria-label": "RSS"))),
    ),
)

// ==========================================
// Content Block Helpers
// ==========================================
#let blog_figure(src, alt, caption) = html.figure(
  html.img(src: src, alt: alt) + html.figcaption(caption),
)

// ==========================================
// Main Layout Root
// ==========================================

#let blog_post(
  kind: page_kind.post,
  main_title: "Main Title",
  subtitle: "Subtitle",
  author: "Author",
  date_published: datetime(day: 1, month: 1, year: 1970),
  read_time_mins: "5",
  tags: ("Tag 1", "Tag 2", "Tag 3"),
  stylesheet: "",
  show_outline: true,
  // typst source file metadata
  post_number: 0,
  content,
) = {
  // setup document
  let filename = ""
  let main_title_slug = slugify(main_title, lower: true, replacement: "-")
  if (kind == page_kind.index) {
    filename = page_kind.index.route + "index.html"
  } else if (kind == page_kind.post) {
    filename = (
      page_kind.post.route + post_id(post_number) + "-" + main_title_slug + ".html"
    )
  }

  document(filename, title: main_title)[
    // =============== Headings ==============
    #let heading_supp = [#(post_id(post_number) + "-" + main_title_slug)]
    #set heading(numbering: "1.1.1 " + sym.dash, depth: 1, supplement: heading_supp)
    #counter(heading).update(0) // reset counter

    // =============== Quotes ================
    #show quote: it => emph(it)

    // =============== Build Document ==============
    #html.html(
      lang: "en",
      id: post_id(post_number),
      blog_head(main_title, stylesheet)
        + html.body(
          blog_nav()
            + html.article(
              blog_header(
                main_title,
                subtitle,
                author,
                date_published,
                read_time_mins,
                tags,
              )
                + html.main()[
                  #if (show_outline) {
                    // Why can't I do: target: #html.h2.where(class: "some-class")
                    outline(title: "Contents", target: heading.where(supplement: heading_supp))
                  }
                  #content
                ],
            )
            + blog_footer(author, "2026"),
        ),
    )
  ]
}
