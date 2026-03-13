#import "001/hello-internet.typ": info as post_001

#let posts = (
  post_001,
)

#import "../blog.typ": PUBLIC_POSTS_ROOT, blog_template, styles

#let pad_left(pad_char, number) = {
  let num_str = str(number)
  let padding_needed = calc.max(0, 3 - num_str.len())
  pad_char * padding_needed + num_str
}

#blog_template(
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
        html.a(
          href: "/" + PUBLIC_POSTS_ROOT + "/" + pad_left("0", p.post_number) + "/" + p.post_filename + ".html",
        )[#p.date_published.display(): #p.main_title --- #p.subtitle],
      )
    }
  ]
]
