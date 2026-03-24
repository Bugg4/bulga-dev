#import "blog-template.typ": blog_post, page_kind, styles
#import "utils.typ": pad_left, post_id, slugify

// Get posts info
#import "posts/post-001.typ": info as post_001
#import "posts/post-002.typ": info as post_002

// Build list of posts
#let posts = (
  post_001,
  post_002,
)

#blog_post(
  kind: page_kind.index,
  main_title: "Index",
  subtitle: "List of my posts",
  author: "Marco Bulgarelli",
  date_published: datetime(day: 12, month: 03, year: 2026),
  read_time_mins: "5 min read",
  tags: (),
  stylesheet: styles.blog,
  // post_filename: "index",
  show_outline: false,
  post_number: 0,
)[


  #html.ul()[
    #for p in posts.rev() {
      html.li(
        link(
          // label("post-" + str(p.post_number)),
          // label will be viable when: https://github.com/typst/typst/issues/7735#:~:text=And%20in%20a%20future%20where%20labels%20can%20be%20used%20in%20code%20mode%20(which%20I%20could%20imagine)%2C%20perhaps%20this%3A

          p.kind.route
            + post_id(p.post_number)
            + "-"
            + slugify(p.main_title, lower: true, replacement: "-")
            + ".html"
            + "#"
            + post_id(p.post_number),
          pad_left("0", 3, p.post_number) + ": " + p.main_title + [ --- ] + p.subtitle,
        ),
      )
    }
  ]
]
