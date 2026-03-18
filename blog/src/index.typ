#import "blog-template.typ": blog_post, styles, routes
#import "utils.typ": pad_left

// Get posts info
#import "posts/post-001.typ": info as post_001
#import "posts/post-002.typ": info as post_002

// Build list of posts
#let posts = (
  post_001,
  post_002,
)

#blog_post(
  route: routes.index,
  main_title: "Index",
  subtitle: "List of my posts",
  author: "Marco Bulgarelli",
  date_published: datetime(day: 12, month: 03, year: 2026),
  read_time: "5 min read",
  tags: (),
  stylesheet: styles.blog,
  post_filename: "index",
  post_number: 0,
)[
  #html.ul()[
    #for p in posts {
      html.li(
        link(
          eval("<" + str(p.post_number) + ">", mode: "code"),
          pad_left("0", 3, p.post_number) + ": " + p.main_title + [ --- ] + p.subtitle,
        ),
      )
    }
  ]
]
