
#import "../blog-template.typ": blog_post, routes, styles, tags

#let info = (
  // post metadata
  route: routes.post,
  main_title: "Hello, Internet!",
  subtitle: "My Blog, My Way",
  author: "Marco Bulgarelli",
  date_published: datetime(day: 11, month: 3, year: 2026),
  read_time: "5 min read",
  tags: (tags.meta, tags.typst),
  stylesheet: styles.blog,
  post_filename: "hello-internet",
  post_number: 1,
)

#blog_post(
  ..info,
)[
  So, uhm... is this thing on? \
  Welcome to my first ever blog post! How exciting!
  This took _much_ longer than I expected, but I'm happy I managed to get it started.

  I won't waste time introducing myself, as that's the job of the #link("about:blank")[About Me] page, which I've yet to write... but I'm sure you'll manage fine in the meantime. \
  Instead, I'd like to talk about how I approached this blog writing thing, which is quite funny now that I'm actually writing it down.

  But let's start from the beginning.

  = Make It Simple, Make It From Scratch

  I like to start projects from scratch. As most developers coding for fun, and not to get shit done often do. \
  No WordPress, No React, no Hugo. \
  I want a simple, fast, accessible and beautiful static site,
  one the same line of the original #link("https://motherfuckingwebsite.com/")[motherfuckingwebsite.com]
  and all the other #link("https://github.com/lyoshenka/awesome-motherfucking-website")[mfw-inspired sites], which I encourage you to check out if you're not familiar. \
  _But_ I also want to enjoy the whole process of writing the website first, and the content later, which may not be as obvious as it sounds. \
  See, I'm a lazy person, and arguably, an even lazier developer. \
  If I don't set the whole thing up to be a an absolute joy to use, I'll get bored or annoyed with it, and won't write a second post. I'm sure that'd leave you, dear reader, in absolute shambles, so I promise to do my best to make this fun and interesting for both me _and_ you!

  So, the first choice I have to make is: which stack should I adopt? \
  The options I went through:

  == Just Raw HTML + CSS
  Ah, they joy of having literally zero dependencies, anside from a text editor. \
  Without a doubt, the most minimal option.
  - Pros:
    - minimalism FTW
    - very powerful as they allow for a great degree of freedom in structuring the page, with no added complexity.
  - Cons:
    - Very verbose and repetitive
    - Source files look cluttery and hard to read once they pass a couple hundreads lines.
    - HTML does not support importing/including snippets from other different files out of the box, so reusing get perry hard.
    - No scripting capabilities, would need javascript

  Overall, Good for structure, too tedious/repetitive for writing. \
  I see myself experiencing too much friction with this method, so it's a no go.

  == Markdown + SSG
  The obvious first choice... for a _sane_ person. \
  Also the de-facto standard, and, I assume, most used method to build static sites. \
  I've already stated I'd like to avoid SSGs, as they can be a bit opinionated in the way they handle the source tree structure. \
  They also kinda hide away the whole markdown compilation process, which I'd prefer to have complete control on.

  - Pros:
    - sane choice
    - Markdown is terse and easy to read

  - Cons:
    - Scripting and content must be separate: the logic resides inside the template, while the content resides in the Markdwon files. I want content and logic in the same file.
    - I just learn to use the SSG instead building everythign myself. Also, I'd end up stealing someone's cool template instead of making my own.

  Tl;dr: I'm not a sane person. Next.

  == Pure Python (???)
  What? \
  Yeah, I write my posts in Python, bruv. \
  Just Kidding, but I did try. \

  I thought #quote[Hey, Python is ergonomic, very flexible, so maybe I can find a way to intertwine written content with Python code in a way that doesn't look ugly, and grants me the full power of an actual programming language] (yeah, sorry HTML folks).

  I had recently learnt about context managers, which, if you wrote any Python at all, you surely used:

  ```python
  with open("file.txt") as f:
      data = f.read()
  ```

  The `with` keyword here allows you to `open()` a file and bind it to the `f` variable without having to close it once you're done; it gets closed automatically once you exit the scope if the `with` block. \
  That's because you're operating inside *context*, which is a construct that can perform predefined actions both _before_ and _after_ the piece of code it wraps. \
  Sounds perfect for writing HTML programmatically!

  This is how I went about implementeing a context manager class which mimics the way you'd write nested HTML elements:

  ```python
  class HTMLTag:
    def __init__(self, tag_name, **kwargs):
        self.tag_name = tag_name
        # Format kwargs into 'key="value"' strings
        self.attributes = "".join([f' {k.replace("_", "-")}="{v}"' for k, v in kwargs.items()])

    def __enter__(self):
        # Print the opening tag when entering the 'with' block
        print(f"<{self.tag_name}{self.attributes}>", end="")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        # Print the closing tag when leaving the 'with' block
        print(f"</{self.tag_name}>")

  ```
  See the `__enter__` and `__exit__` methods? Those are the secret sauce of context managers. \
  The code nested inside `with` statements is executed between those two. \
  You'd use it like this:

  ```python
  with HTMLTag("div", _class="container", id="main"):
      with HTMLTag("h1", style="color: blue;"):
          print("Hello, World!", end="")
      with HTMLTag("p"):
          print("This was generated using a Python context manager.", end="")
  ```
  And that would produce the nested HTML structure you'd expect:

  ```html
  <div class="container" id="main">
    <h1 style="color: blue;">Hello, World!</h1>
    <p>This was generated using a Python context manager.</p>
  </div>
  ```

  You can likely see how, with some work to prettify the API, this could become quite a usable pattern. The idea is simply that we manage the HTML nesting using python contexts.\
  We could also make a derived classes for each single HTML tag, as to avoid some code and make the code prettier:

  ```python
  class Div(HTMLTag):
    def __init__(self, **kwargs):
        # Automatically handle the 'class' keyword conflict
        if 'cls' in kwargs:
          kwargs['class'] = kwargs.pop('cls')
          super().__init__("div", **kwargs)

  class H1(HTMLTag):
    def __init__(self, **kwargs):
      super().__init__("h1", **kwargs)

  class P(HTMLTag):
    def __init__(self, **kwargs):
      super().__init__("p", **kwargs)
  ```

  This is all fine and dandy, but there's a not so subtle usability problem: We have to write our actual content using print statements and strings. \
  This is a major annoyance. \
  Assume we'd want to make a Table of Contents component. It's pretty common to have an index of some sort in pretty much any artcile, right? \
  And ToCs usually go at, or close to, the very beginning of the article, correct? \
  But how could we construct a ToC without having printed all the content first? Well, we can't.

  To solve this issue, we'd have to complicate the structure of our simple (for now) HTML renderer, and think of a way to access the HTML node tree once it's fully constructed, analyize it, and then go back at the beginning to insert another element, a ToC in this case.

  This is doable, don't get me wrong, but it _feels_ out of scope for this project. \
  It _feels_ like there must be a simpler way to write HTML programmatically without having to build a full fledged HTML Node tree representation.

  Remember? I'm lazy. Plus, if I wanted to use something like that I'd adopt one of the existing libraries, like #link("https://github.com/Knio/dominate")[Dominate].

  So, final verdict for Python: Great for logic, terrible for writing content.

  The ideal workflow I'm searching for would let me *just write the damn text*, without wrapping every sentence in quotes, or polluting the document with function calls and endless nesting, while still giving me the power of a real programming language behind the scenes.

  = Typst
  Then, the revelation.

  I knew about this language the whole time, since 2023 in fact. \
  I had tried it for a bit, but wrote it off as not yet mature enough for whatever I was doing at the time.

  I also happened to use it for a fairly recent project, a technical documentation automation pipeline I was experimenting with for work, but it never occurred to me to use it for a blog, until now.

  For the uninitiade, #link("https://typst.app/docs/")[Typst] describes itself as follows:

  #quote[
    [...] a new markup-based typesetting system for the sciences. It is designed to be an alternative both to advanced tools like LaTeX and simpler tools like Word and Google Docs. Our goal with Typst is to build a typesetting tool that is highly capable and a pleasure to use.
  ]

  That is *_EXACTLY_* what I'm looking for.

  Turns out Typst also has an HTML export feature, but it's still in beta and not stable, nor complete. \

  _Buuuuuut..._

  It is _so_ nice to write in. \
  It's basically Markdown on steroids, and Turing complete. \
  Here's the official #link("https://github.com/typst/typst")[GitHub repo], check it out if you've never heard of it.

  Here's my blog template function, as an example of its syntax:

  ```typst
  #let blog_post(
    route: "",
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
    // setup document
    document(route + post_filename + ".html", title: main_title)[
      // =============== Headings ==============
      #set heading(numbering: "1.1.1 " + sym.dash)

      // =============== Quotes ================
      #show quote: it => emph(it)

      // =============== Build Document ==============
      #html.html(
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
    ]
  }
  ```
  What I'm doing is defining a `blog_template()` function which takes arguments in the form of a dictionary. \
  Those args will act as a centralized place to setup all the metadata about my post. \
  What I like about this approach, is that the metadata is defined all at once, in the same place, like you'd do inside the YAML front matter of a markdown file.

  Inside the curly braces I then have a couple of `set` and `show` rules, which are a concept particular to Typst:
  - `set` rules allow me pre-set parameters for #link("https://typst.app/docs/reference/foundations/function/#element-functions")[element functions] that get called inside this template. Imagine it like a macro that "fixes" the specified parameters of a functions to the specified values, so we don't have to set theme each time.
  TODO: Make practical example
  - `show` rules allow me to _redefine_ how those elements look, and completly change their structure.
  for example, I could redefine all the appearances of bold text to always be surrounded by red amoguses (or amogi?):

  ```typst
  #show strong: it => [#text(fill: red, "ඞ") #it #text(fill: red, "ඞ")]
  ```

  #html.span("ඞ", style: "color:red") *sus* #html.span("ඞ", style: "color:red") \
  A very powerful ability, to be used with caution.


  TODO: Transition to saying we need to build multiple docs --> makefile ? it's messy --> bundle feature is available in git version


  == Some notes

  - talk about html feature being in beta, but stable enough for my use case, and how it allows me to write HTML in a more natural way, without the need for string concatenation or anything like that.

  - Talk about bundle feature being merged 5 days before starting to write teh blog, and how it saved me from the makefile mess





] #eval("<" + str(info.post_number) + ">")

