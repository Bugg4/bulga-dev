#import "../../blog.typ": blog_template, styles, tags

#let info = (
  // post metadata
  main_title: "Hello, Internet!",
  subtitle: "To Write a Blog Post, You Must First Introduce an ACE Vulnerability in Your Markup Language",
  author: "Marco Bulgarelli",
  date_published: datetime(day: 11, month: 3, year: 2026),
  read_time: "5 min read",
  tags: (tags.meta, tags.typst),
  stylesheet: styles.blog,
  post_filename: "hello-internet",
  post_number: 1,
)

#blog_template(
  ..info,
)[

  So, uhm... is this thing on? \
  Welcome to my first ever blog post! How exciting!
  This took *MUCH* longer than I expected, but I'm happy I managed to get it started.

  I won't waste time introducing myselft, as that's the job of the #link("about:blank")[About Me] page, which I've yet to write,
  but I'm sure you'll manage fine in the meantime. \
  Insteed, as I'd like to talk a bit about how I approached this blog writing thing, which is quite funny
  to actually write word for word, now that I'm actually doing it.

  But let's start from the beginning.

  == Make it simple, Make it From Scratch

  I like to start projects from scratch. As most developers that write something for fun, and not to get shit done, do \
  No WordPress, No React, no Hugo. \
  I want a simple, fast, accessible and beautiful static site,
  one the same line of the original #link("https://motherfuckingwebsite.com/")[motherfuckingwebsite.com]
  and all the other #link("https://github.com/lyoshenka/awesome-motherfucking-website")[mfw-inspired sites], which I encourage you to check out if you're not familiar.

  So, the first choice I have to make is: which markup language should I choose?
  My options:

  === Just raw HTML
  - Pros: cool at first, very powerful as it allows for a great degree of freedom with basically zero complexity.
  - Cons: very repetitive, very verbose, source files look cluttery, reusing code among multiple pages can become hell to maintain, no scripting.

  I see myself experiencing too much friction using it, so it's a no go.

  === Markdown
  The obvious first choice... for a sane person.
  - Pros: sane choice, very terse, low friction, ubiquitous.
  - Cons: Limited expression power, no scripting, no way to reuse code across pages, and worst of all: no way to customize the structure of the HTML output unless I use some weird extensions, which would require passing the source files throug a framwwork or a static site generatr anyway, *AND* would make the syntax uglier, which is the exact opposite of what I want.
  So, also a no go.

  === Pure Python (???)
  What? \
  Yeah, I wrote my blog post in Python, bruv. \
  Just Kidding, but I did try. \

  Let me open a funny parenthesis for a moment, and tell you about that. \
  I thought: _"Hey, I know Python, it's very ergonomic, very flexible, so maybe I can find a way to intertwine written content with
  Python code in a way that doesn't look ugly, and grants me the full power of an actual programming language"_ (yeah, sorry HTML folks).

  I had recently learnt about context managers, which, if you wrote any Python at all, you surely used.
  It's the costruct the allows you to do something like:

  ```python
  with open("file.txt") as f:
      data = f.read()
  ```

  The `with` keyword opens a _context_, which allows you to execute some code before and after the block of code it wraps. \
  Sounds perfect for writing HTML programmatically! All we need is somethis like this:

  ```python
  items = ["a", "b", "c"]
  with html.ul() as ul:
      for item in items:
          ul.li(item)
  ```

  - Python con: writing _content_ is clunky because we have to use strings, so no syntax highlighting out of the box, and intepolating code with content becomes kinda verbose with the `with` spam.
  - talk about choosing typst and creating the blog template
  - talk about html feature being in beta, but stable enough for my use case, and how it allows me to write HTML in a more natural way, without the need for string concatenation or anything like that.

  - talk about wanting to be able to execute arbitrary code which typst does not fully allow.
    there 's the metadata workaroun, but it's ugly and requires a two-step compilation.
    So if I wanna keep typst, I have to introduce \#exec
]
