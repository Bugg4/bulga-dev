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
  Instead, I'd like to talk a bit about how I approached this blog writing thing, which is quite funny
  to actually write word for word, now that I'm actually doing it.

  But let's start from the beginning.

  == Make it simple, Make it From Scratch

  I like to start projects from scratch. As most developers that code for fun, and not to get shit done do. \
  No WordPress, No React, no Hugo. \
  I want a simple, fast, accessible and beautiful static site,
  one the same line of the original #link("https://motherfuckingwebsite.com/")[motherfuckingwebsite.com]
  and all the other #link("https://github.com/lyoshenka/awesome-motherfucking-website")[mfw-inspired sites], which I encourage you to check out if you're not familiar. \
  _But_ I also want to enjoy the whole process of wrting the website first, and the content later, which may not be as obvious as it sounds. \
  I see, I'm a lazy person, and arguably, an even lazier developer. \
  If I don't set the whole thing up to be a an absolute joy to use, I'll get borded or annoyed, and won't write a second post. I'm sure that'd leave you, dear reader, in absolute shables, so I promise to do my best to make this fun and interesting for both me _and_ you!

  So, the first choice I have to make is: which markup language should I choose? \
  My options:

  === Just raw HTML
  - Pros:
    - cool at first
    - very powerful as it allows for a great degree of freedom with basically zero complexity.
  - Cons:
    - very repetitive
    - very verbose
    - source files look cluttery and hard to read
    - reusing code among multiple pages can become hell to maintain
    - no scripting capabilities, would need javascript to make it dynamic

  I see myself experiencing too much friction using it, so it's a no go.

  === Markdown
  The obvious first choice... for a _sane_ person. \
  Also the de-facto standard use buy pretty much every static site generator out there. \
  - Pros:
    - sane choice
    - very terse
    - easy to read
    - ubiquitous

  - Cons:
    - Limited styling expression power
    - no scripting
    - no way to reuse code across pages
    - and worst of all: no way to customize the structure of the HTML output, unless I use some weird extensions, which would require passing the source files throug a framework or SSG anyway, *AND* would make the syntax uglier, which is the exact opposite of what I want.

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

  == Typst
  Then, the revelation.

  I knew about this language the whole time, since 2023 in fact, I had tried it for a bit, but wrote it off as not yet mature enough for whatever I was doing at the time.

  I also happened to use it for a fairly recent project, a technical documentation automation pipeline I was experimenting with for work, but it never occurred to me to use it for a blog, until now.

  _TODO: explain typst in short here._

  Turns out Typst does have an HTML export feature, but it's still in beta and not stable, nor complete. \

  _Buuuuuut..._

  It is _so_ nice to write in. \
  It's basically Markdown on steroids, and Turing complete. \
  It's meant to be a modern replacement for LaTeX, here's the official #link("https://github.com/typst/typst")[GitHub repo], check it out if you've never heard of it.

  Here's my blog template function, as an example of its syntax:

  #html.details(
    html.summary("Expand Code")
      + ```typst
      #let blog_template(
        main_title: "Main Title",
        subtitle: "Subtitle",
        author: "Author",
        date_published: datetime(day: 1, month: 1, year: 1970),
        read_time: "Read Time",
        tags: ("Tag 1", "Tag 2", "Tag 3"),
        stylesheet: "",
        // typst source file metadata
        post_number: 0,
        post_filename: "some-title",
        content,
      ) = {
        // =============== Headings ==============
        set heading(numbering: "01.")
        show heading: it => {
          if it.level <= 1 {
            html.h1(it.body)
          } else {
            html.elem(
              "h" + str(it.level),
              html.span(it.numbering, class: "section-num") + " " + it.body,
            )
          }
        }

        // =============== Build Document ==============
        html.html(
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
                    + html.main(content),
                )
                + blog_footer(author, "2026"),
            ),
        )
      }
      ```,
  )
  \
  And here's how it looks in use:

  #html.details(
    html.summary("Expand Code")
      + ```typst
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
        == Some Title

        And here I can just write normal typst.\
        I can use *bold*, _italics_ ...

        Lists
        - item 1
        - item 2

        You got the idea
      ]
      ```,
  )
  \
  And that gets rendered as follows:

  == Some Title

  And here I can just write normal typst.\
  I can use *bold*, _italics_ ...

  Lists
  - item 1
  - item 2

  You got the idea



  == Some notes

  Try writing CSS in typst directly, using shared variables for colors and styles, the build css directly into the components with show/set rules

  - Python con: writing _content_ is clunky because we have to use strings, so no syntax highlighting out of the box, and intepolating code with content becomes kinda verbose with the `with` spam.
  - talk about choosing typst and creating the blog template
  - talk about html feature being in beta, but stable enough for my use case, and how it allows me to write HTML in a more natural way, without the need for string concatenation or anything like that.

  - talk about wanting to be able to execute arbitrary code which typst does not fully allow.
    there 's the metadata workaroun, but it's ugly and requires a two-step compilation.
    So if I wanna keep typst, I have to introduce \#exec
]
