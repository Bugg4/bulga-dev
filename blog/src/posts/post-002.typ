
#import "../blog-template.typ": blog_post, page_kind, styles, tags

#let info = (
  kind: page_kind.post,
  main_title: "Main Title",
  subtitle: "Subtitle",
  author: "Marco Bulgarelli",
  date_published: datetime(day: 11, month: 3, year: 2026),
  read_time_mins: "5 min read",
  tags: (tags.meta, tags.typst),
  stylesheet: styles.blog,
  // post_filename: "002-test",
  post_number: 2,
)

#show: blog_post.with(
  ..info,
)

= Testing testing
This is just a test post

