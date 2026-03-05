// ==========================================
// Layout Components
// ==========================================

#let blog_head(title, stylesheet) = {
  html.elem("head")[
    #html.meta(charset: "utf-8")
    #html.meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
    #html.title(title)
    #html.link(rel: "stylesheet", href: stylesheet)
  ]
}



#let nav_bar() = html.elem(
  "nav",
  html.elem(
    "a",
    attrs: (href: "/", class: "nav-brand"),
  )[Home]
    + html.elem(
      "a",
      attrs: (href: "#", class: "nav-link"),
    )[cd ..],
)


#let blog_header(title, subtitle, author, date_published, read_time, tags) = html.elem(
  "header",
  html.elem(
    "h1",
    attrs: (class: "blog-title"),
    title + html.elem("br") + html.elem("span", attrs: (class: "blog-subtitle"), subtitle),
  )
    + html.elem(
      "ul",
      attrs: (class: "metadata"),
      html.elem(
        "li",
        attrs: (class: "author"),
        author,
      )
        + html.elem(
          "li",
          attrs: (class: "date-published"),
          date_published,
        )
        + html.elem(
          "li",
          attrs: (class: "read-time"),
          read_time,
        )
        + html.elem(
          "ul",
          attrs: (class: "tags"),
          tags
            .map(t => {
              html.elem("li", attrs: (class: "tag"), "#" + t)
            })
            .join(),
        ),
    ),
)

#let blog_footer(author, year) = html.elem(
  "footer",
  html.elem("p", attrs: (class: "footer-copy"), "© " + str(year) + " " + author + ". All rights reserved.")
    + html.elem(
      "ul",
      attrs: (class: "footer-links"),
      html.li(html.elem("a", attrs: (href: "#", "aria-label": "Github")))
        + html.li(html.elem("a", attrs: (href: "#", "aria-label": "Twitter")))
        + html.li(html.elem("a", attrs: (href: "#", "aria-label": "RSS"))),
    ),
)

// ==========================================
// Content Block Helpers
// ==========================================
#let blog_p(content) = html.elem("p", content)
#let blog_quote(content) = html.elem("blockquote", content)

#let section_heading(num, title) = html.elem(
  "h2",
  html.elem("span", attrs: (class: "section-num"), num + ".") + " " + title,
)

#let blog_figure(src, alt, caption) = html.elem(
  "figure",
  html.elem("img", attrs: (src: src, alt: alt)) + html.elem("figcaption", caption),
)

// ==========================================
// Main Layout Root
// ==========================================
#let blog_post(
  main_title,
  subtitle,
  author,
  date_published,
  read_time,
  tags,
  stylesheet,
  content,
) = html.elem("html", attrs: (lang: "en"))[
  #blog_head(main_title, stylesheet)

  #html.body(
    nav_bar()
      + html.article(
        blog_header(main_title, subtitle, author, date_published, read_time, tags)
          + html.main[
            #content
          ],
      )
      + blog_footer(author, "2026"),
  )
]

// ==========================================
// Document Execution
// ==========================================
#blog_post(
  "Hello, Internet!",
  "My First Blog Post",
  "Marco Bulgarelli",
  "Oct 24, 2026",
  "5 min read",
  ("reverse-engineering", "assembly", "hardware"),
  "main.css",
)[
  #blog_p[
    Last week, I got my hands on a proprietary IoT device that was acting completely erratic.
    Before tossing it into the hardware graveyard, I decided to hook up my UART adapter and see
    what was going on under the hood. What I found was a beautifully chaotic custom bootloader.
  ]

  #section_heading("01", "Initial Reconnaissance")

  #blog_p[
    The first step was identifying the test pads on the PCB. After probing around with a multimeter,
    I managed to locate Connecting it to my logic analyzer revealed a standard
    115200 baud rate. However, the output wasn't your typical U-Boot string. It was obfuscated.
  ]

  #blog_figure(
    "https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1000&q=80",
    "Close up of a green printed circuit board with traces and chips",
    "Fig 1. Tracing the UART pads on the primary logic board.",
  )

  #blog_quote[
    "Security through obscurity is a weak defense, but it sure makes for a fun Friday night."
  ]

  #section_heading("02", "Dumping the Flash")

  #blog_p[
    To figure out the encryption routine, I needed the binary. I desoldered the SPI flash chip and
    dumped it using Connecting my SOP8 clip required a bit of finesse, but eventually the payload was extracted.
  ]

  #blog_figure(
    "https://images.unsplash.com/photo-1555664424-778a1e5e1b48?auto=format&fit=crop&w=1000&q=80",
    "Electronics workspace with cables, a laptop, and a logic analyzer",
    "Fig 2. The extraction setup hooked into the logic analyzer.",
  )

  #blog_p[
    Here is a snippet of the decryption loop I found loaded in memory:
  ]

  #blog_p[
    As you can see, the "encryption" was merely a static XOR key. By applying this key
    to the data payload, the entire firmware revealed itself as standard ARM Cortex-M architecture.
    The rest of the analysis was straightforward via Ghidra.
  ]

  #blog_p[
    In the next post, I'll walk through how I patched this bootloader to skip the signature
    check entirely, allowing us to flash custom firmware over the air. Stay tuned.
  ]


]
