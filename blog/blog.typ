// ==========================================
// Layout Components
// ==========================================

#let PUBLIC_ROOT = ".dist"
#let PUBLIC_POSTS_ROOT = "posts"

#let styles = (
  blog: "../../styles/blog.css",
)

#let shared = (
  favicon: "../../shared/favicon.png",
)

#let tags = (
  meta: "meta",
  typst: "typst",
)

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
#let blog_template(
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
  // ============================= Headings
  set heading(numbering: "1")
  show heading: it => {
    if it.level == 1 {
      html.h1(it.body)
    } else if it.level == 2 {
      html.h2(html.span(it.numbering, class: "section-num") + " " + it.body)
    } else if it.level == 3 {
      html.h3(html.span(it.numbering, class: "section-num") + " " + it.body)
    } else if it.level == 4 {
      html.h4(html.span(it.numbering, class: "section-num") + " " + it.body)
    } else if it.level == 5 {
      html.h5(html.span(it.numbering, class: "section-num") + " " + it.body)
    } else if it.level == 6 {
      html.h6(html.span(it.numbering, class: "section-num") + " " + it.body)
    }
  }

  // ============================= Build Document
  html.html(
    lang: "en",
    blog_head(main_title, stylesheet)
      + html.body(
        blog_nav()
          + html.article(
            blog_header(main_title, subtitle, author, date_published, read_time, tags) + html.main(content),
          )
          + blog_footer(author, "2026"),
      ),
  )
}
