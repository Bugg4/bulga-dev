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

#let page_types = (
  post: "post",
  index: "index",
)

// ==========================================
// Layout Components
// ==========================================

#let blog_head(title, stylesheet) = html.head(
  html.meta(charset: "utf-8")
    + html.meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
    + html.title(title)
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
    class: "blog-title",
    title + html.br() + html.span(class: "blog-subtitle", subtitle),
  )
    + html.ul(
      class: "blog-metadata",
      html.li(class: "author", author)
        + html.li(class: "date-published", date_published.display())
        + html.li(class: "read-time", read_time)
        + html.ul(
          class: "tags",
          tags.map(t => html.li(class: "tag", t)).join(),
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
  page_type: "",
  main_title: "Main Title",
  subtitle: "Subtitle",
  author: "Author",
  date_published: datetime(day: 1, month: 1, year: 1970),
  read_time: "Read Time",
  tags: ("Tag 1", "Tag 2", "Tag 3"),
  stylesheet: "",
  // typst source file metadata
  post_number: 0,
  post_filename: "some-title",
  content,
) = {
  // setup document
  let path = ""
  if (page_type == page_types.post) {
    path = "post/"
  } else if (page_type == page_types.index) {
    path = "./"
  }
  document(path + post_filename + ".html", title: main_title)[
    // =============== Headings ==============
    #set heading(numbering: "01.")
    #show heading: it => {
      if it.level <= 1 {
        html.h1(it.body)
      } else {
        html.elem(
          "h" + str(it.level),
          html.span(it.numbering, class: "section-num") + " " + it.body,
        )
      }
    }

    // =============== Build Document ==============
    #html.html(
      lang: "en",
      blog_head(main_title, stylesheet)
        + html.body(
          blog_nav()
            + html.article(
              blog_header(
                main_title,
                subtitle,
                author,
                date_published,
                read_time,
                tags,
              )
                + html.main(content),
            )
            + blog_footer(author, "2026"),
        ),
    )
  ]
}
