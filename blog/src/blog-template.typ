#import "utils.typ": heading_with_id

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

#let routes = (
  post: "post/",
  index: "/",
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
  route: "",
  main_title: "Main Title",
  subtitle: "Subtitle",
  author: "Author",
  date_published: datetime(day: 1, month: 1, year: 1970),
  read_time: "Read Time",
  tags: ("Tag 1", "Tag 2", "Tag 3"),
  stylesheet: "",
  show_outline: true,
  // typst source file metadata
  post_number: 0,
  post_filename: "some-title",
  content,
) = {
  // setup document
  document(route + post_filename + ".html", title: main_title, keywords: str(post_number))[
    // =============== Headings ==============
    #set heading(numbering: "1.1.1 " + sym.dash, depth: 1)
    #counter(heading).update(0) // reset counter

    //https://github.com/typst/typst/issues/2926
    /*     #show heading: it => {
      let key = str(post_number) + "-" + lower(post_filename).replace(" ", "-")
      return [
        #it
        #v(-1em)
        #figure(
          kind: "heading",
          numbering: (..numbers) => numbering(heading-numbering, ..(counter(heading).get())),
          supplement: "Section",
        )[]
        #label(key)
      ]
    } */

    // =============== Quotes ================
    #show quote: it => emph(it)

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
                + html.main()[
                  #if (show_outline) {
                    outline(title: "Contents", target: heading)
                  }
                  #content
                ],
            )
            + blog_footer(author, "2026"),
        ),
    )
  ]
}
