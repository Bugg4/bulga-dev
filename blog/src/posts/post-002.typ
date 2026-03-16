
#import "../blog-template.typ": blog_post, page_types, styles, tags

#let info = (
  // post metadata
  page_type: page_types.post,
  main_title: "Main Title",
  subtitle: "Subtitle",
  author: "Marco Bulgarelli",
  date_published: datetime(day: 11, month: 3, year: 2026),
  read_time: "5 min read",
  tags: (tags.meta, tags.typst),
  stylesheet: styles.blog,
  post_filename: "002-test",
  post_number: 2,
)

#blog_post(
  ..info,
)[
  == Testing testing
  This is just a test post
] #eval("<" + str(info.post_number) + ">")

