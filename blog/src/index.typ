#import "blog-template.typ": blog_post, page_types, styles

// Get posts info
#import "posts/post-001.typ": info as post_001

// Build list of posts
#let posts = (
  post_001,
)

#blog_post(
  page_type: page_types.index,
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
  == Here is the index of my posts:


  #html.ul()[
    #for p in posts {
      html.li(
        link(
          eval("<" + str(p.post_number) + ">", mode: "code"),
          str(p.post_number) + ": " + p.main_title + [ --- ] + p.subtitle,
        ),
      )
    }
  ]
]
