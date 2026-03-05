// ==========================================
// Layout Components
// ==========================================

#let blog_head(title, stylesheet) = html.elem(
  "head",
  html.elem("title", title)
    + html.elem("meta", attrs: (charset: "utf-8"))
    + html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1.0"))
    + html.elem("link", attrs: (rel: "stylesheet", href: stylesheet)),
)



#let nav_bar() = html.elem("div", attrs: (class: "container"))[
  #html.elem(
    "nav",
  )[
    #html.elem(
      "a",
      attrs: (href: "/", class: "nav-brand"),
    )[SYS_INIT]

    #html.elem(
      "a",
      attrs: (href: "#", class: "nav-link"),
    )[cd ..]
  ]

]

#let article_header(title_main, title_gradient, author, date_published, read_time, tags) = html.elem(
  "header",
  html.elem("h1", title_main + html.elem("br") + html.elem("span", attrs: (class: "blog-subtitle"), title_gradient))
    + html.elem(
      "div",
      attrs: (class: "meta"),
      html.elem(
        "div",
        attrs: (class: "meta-item"),
        html.elem("span", author),
      )
        + html.elem(
          "span",
          attrs: (class: "meta-divider"),
          "|",
        )
        + html.elem(
          "div",
          attrs: (class: "meta-item"),
          html.elem("span", date_published),
        )
        + html.elem(
          "span",
          attrs: (class: "meta-divider"),
        )[|]
        + html.elem("div", attrs: (class: "meta-item"), html.elem(
          "span",
          read_time,
        )),
    )
    + html.elem(
      "div",
      attrs: (class: "tags"),
      tags
        .map(t => {
          let t_class = if t == "reverse-engineering" { "tag cyan" } else if t == "assembly" { "tag fuchsia" } else {
            "tag"
          }
          html.elem("span", attrs: (class: t_class), "#" + t)
        })
        .join(),
    ),
)

#let blog_footer(author, year) = html.elem("div", attrs: (class: "container"), html.elem("footer", html.elem(
  "div",
  attrs: (class: "footer-content"),
  html.elem("p", attrs: (class: "footer-copy"), "© " + str(year) + " " + author + ". All rights reserved.")
    + html.elem(
      "div",
      attrs: (class: "footer-links"),
      html.elem("a", attrs: (href: "#", "aria-label": "Github"), html.elem(
        "svg",
        attrs: (xmlns: "http://www.w3.org/2000/svg", viewBox: "0 0 24 24"),
        html.elem("path", attrs: (
          d: "M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22",
        )),
      ))
        + html.elem("a", attrs: (href: "#", "aria-label": "Twitter"), html.elem(
          "svg",
          attrs: (xmlns: "http://www.w3.org/2000/svg", viewBox: "0 0 24 24"),
          html.elem("path", attrs: (
            d: "M23 3a10.9 10.9 0 0 1-3.14 1.53 4.48 4.48 0 0 0-7.86 3v1A10.66 10.66 0 0 1 3 4s-4 9 5 13a11.64 11.64 0 0 1-7 2c9 5 20 0 20-11.5a4.5 4.5 0 0 0-.08-.83A7.72 7.72 0 0 0 23 3z",
          )),
        ))
        + html.elem("a", attrs: (href: "#", "aria-label": "RSS"), html.elem(
          "svg",
          attrs: (xmlns: "http://www.w3.org/2000/svg", viewBox: "0 0 24 24"),
          html.elem("path", attrs: (d: "M4 11a9 9 0 0 1 9 9"))
            + html.elem("path", attrs: (d: "M4 4a16 16 0 0 1 16 16"))
            + html.elem("circle", attrs: (cx: "5", cy: "19", r: "1")),
        )),
    ),
)))

// ==========================================
// Content Block Helpers
// ==========================================
#let blog_p(content) = html.elem("p", content)
#let blog_quote(content) = html.elem("blockquote", content)
#let inline_code(content) = html.elem("code", content)

#let section_heading(num, title) = html.elem(
  "h2",
  html.elem("span", attrs: (class: "section-num"), num + ".") + " " + title,
)

#let blog_figure(src, alt, caption) = html.elem(
  "figure",
  html.elem("img", attrs: (src: src, alt: alt)) + html.elem("figcaption", caption),
)

#let code_wrapper(content) = html.elem("div", attrs: (class: "code-wrapper"), html.elem("pre", html.elem(
  "code",
  content,
)))

// Syntax Highlighting Spans
#let syn_addr(c) = html.elem("span", attrs: (class: "syn-addr"), c)
#let syn_comment(c) = html.elem("span", attrs: (class: "syn-comment"), c)
#let syn_keyword(c) = html.elem("span", attrs: (class: "syn-keyword"), c)

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
  #blog_head(main_title + subtitle + " - " + author + " Blog", stylesheet)

  #html.elem("body")[
    #nav_bar()

    #html.elem("main", attrs: (class: "container"))[
      #html.elem("article")[
        #article_header(main_title, subtitle, author, date_published, read_time, tags)

        #html.elem("div", attrs: (class: "content"))[
          #content
        ]
      ]
    ]

    #blog_footer(author, "2026")
  ]
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
    I managed to locate #inline_code[TX], #inline_code[RX], and #inline_code[GND]. Connecting it to my logic analyzer revealed a standard
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
    dumped it using #inline_code[flashrom]. Connecting my SOP8 clip required a bit of finesse, but eventually the payload was extracted.
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
    As you can see, the "encryption" was merely a static XOR key (#inline_code[0xAA]). By applying this key
    to the data payload, the entire firmware revealed itself as standard ARM Cortex-M architecture.
    The rest of the analysis was straightforward via Ghidra.
  ]

  #blog_p[
    In the next post, I'll walk through how I patched this bootloader to skip the signature
    check entirely, allowing us to flash custom firmware over the air. Stay tuned.
  ]


]
