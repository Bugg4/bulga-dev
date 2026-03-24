
#import "../blog-template.typ": blog_figure, blog_post, routes, styles, tags

#let info = (
  // post metadata
  route: routes.post,
  main_title: "Hello, Internet!",
  subtitle: "My Blog, My Way",
  author: "Marco Bulgarelli",
  date_published: datetime(day: 22, month: 3, year: 2026),
  read_time: "10 min read",
  tags: (tags.meta, tags.typst),
  stylesheet: styles.blog,
  post_filename: "hello-internet",
  post_number: 1,
)

#show: blog_post.with(
  ..info,
)

So, uhm... is this thing on? \
Welcome to my first ever blog post! How exciting!
This took _much_ longer than I expected, but I'm happy I managed to get it started.

I won't waste time introducing myself, as that's the job of the #link("about:blank")[About Me] page, which I've yet to write... but I'm sure you'll manage fine in the meantime. \
Instead, I'd like to talk about how I approached this blog writing thing, which is quite funny now that I'm actually writing it down.

But let's start from the beginning.


= Make It Simple, Make It From Scratch


I like to start projects from scratch. As most developers coding for fun, and not to get shit done, often do. \
No WordPress, No React, no Hugo. \
I want a simple, fast, accessible and beautiful static site,
on the same line of the original #link("https://motherfuckingwebsite.com/")[motherfuckingwebsite.com]
and all the other #link("https://github.com/lyoshenka/awesome-motherfucking-website")[mfw-inspired sites], which I encourage you to check out if you're not familiar. \
_But_ I also want to enjoy the whole process of writing the website first, and the content later, which may not be as obvious as it sounds. \
See, I'm a lazy person, and arguably, an even lazier developer. \
If I don't set the whole thing up to be an absolute joy to use, I'll get bored or annoyed with it, and won't write a second post. I'm sure that'd leave you, dear reader, in absolute shambles, so I promise to do my best to make this fun and interesting for both me _and_ you!

So, the first choice I have to make is: which stack should I adopt? \
The options I went through:

== Just Raw HTML + CSS
Ah, the joy of having literally zero dependencies, aside from a text editor. \
Without a doubt, the most minimal option.
- Pros:
  - minimalism FTW
  - very powerful as they allow for a great degree of freedom in structuring the page, with no added complexity.
- Cons:
  - Very verbose and repetitive
  - Source files look cluttered and hard to read once they pass a couple hundred lines.
  - HTML does not support importing/including snippets from other different files out of the box, so reusing gets pretty hard.
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
  - Scripting and content must be separate: the logic resides inside the template, while the content resides in the Markdown files. I want content and logic in the same file.
  - I just learn to use the SSG instead of building everything myself. Also, I'd end up stealing someone's cool template instead of making my own.

Tl;dr: I'm not a sane person. Next.

== Pure Python (???)
What? \
Yeah, I write my posts in Python, bruv. \
Just Kidding, but I did try. \

I thought #quote[Hey, Python is ergonomic, very flexible, so maybe I can find a way to intertwine written content with Python code in a way that doesn't look ugly, and grants me the full power of an actual programming language] (yeah, sorry HTML folks).

I had recently learned about context managers, which, if you wrote any Python at all, you surely used:

```python
with open("file.txt") as f:
    data = f.read()
```

The `with` keyword here allows you to `open()` a file and bind it to the `f` variable without having to close it once you're done; it gets closed automatically once you exit the scope if the `with` block. \
That's because you're operating inside *context*, which is a construct that can perform predefined actions both _before_ and _after_ the piece of code it wraps. \
Sounds perfect for writing HTML programmatically!

This is how I went about implementing a context manager class which mimics the way you'd write nested HTML elements:

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
We could also make derived classes for each single HTML tag, as to avoid some code and make the code prettier:

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
Assume we'd want to make a Table of Contents component. It's pretty common to have an index of some sort in pretty much any article, right? \
And ToCs usually go at, or close to, the very beginning of the article, correct? \
But how could we construct a ToC without having printed all the content first? Well, we can't.

To solve this issue, we'd have to complicate the structure of our simple (for now) HTML renderer, and think of a way to access the HTML node tree once it's fully constructed, analyize it, and then go back at the beginning to insert another element, a ToC in this case.

This is doable, don't get me wrong, but it _feels_ out of scope for this project. \
It _feels_ like there must be a simpler way to write HTML programmatically without having to build a fully-fledged HTML Node tree representation.

Remember? I'm lazy. Plus, if I wanted to use something like that I'd adopt one of the existing libraries, like #link("https://github.com/Knio/dominate")[Dominate].

So, final verdict for Python: Great for logic, terrible for writing content.

The ideal workflow I'm searching for would let me *just write the damn text*, without wrapping every sentence in quotes, or polluting the document with function calls and endless nesting, while still giving me the power of a real programming language behind the scenes.

= Typst
Then, the revelation.

I knew about this language the whole time, since 2023 in fact. \
I had tried it for a bit, but wrote it off as not yet mature enough for whatever I was doing at the time.

I also happened to use it for a fairly recent project, a technical documentation automation pipeline I was experimenting with for work, but it never occurred to me to use it for a blog, until now.

For the uninitiated, #link("https://typst.app/docs/")[Typst] describes itself as follows:

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
- `set` rules allow me to preset parameters for #link("https://typst.app/docs/reference/foundations/function/#element-functions")[element functions] that get called inside this template. Imagine it like a macro that "fixes" the specified parameters of a function to the specified values, so we don't have to set them each time. \
  For instance, `#set heading(numbering: "1.a ")` would make all headings throughout the document automatically number themselves following that specific pattern. Set it once, and forget it!
- `show` rules allow me to _redefine_ how those elements look, and completely change their structure.
for example, I could redefine all the appearances of bold text to always be surrounded by red amoguses (or amogi?):

```typst
#show strong: it => [#text(fill: red, "ඞ") #it #text(fill: red, "ඞ")]
```

#html.span("ඞ", style: "color:red") *sus* #html.span("ඞ", style: "color:red") \
I know, a very powerful ability, to be used with caution.

But don't get distracted.\
What we're here for, and the main selling point of Typst, to me, is how naturally you can intertwine plain text and actual code. That's where I see the real beauty of this tool. \
To give you a taste, here's the exact source code for the intro you just read, straight from this very file:

```typst
#blog_post(
  ..info,
)[
  So, uhm... is this thing on? \
  Welcome to my first ever blog post! How exciting!
  This took _much_ longer than I expected, but I'm happy
  I managed to get it started.

  I won't waste time introducing myself, as that's the job
  of the #link("about:blank")[About Me] page, which I've yet
  to write... but I'm sure you'll manage fine in the meantime. \
  Instead, I'd like to talk about how I approached this
  blog writing thing, which is quite funny now that
  I'm actually writing it down.
]
```

See how clean that is? \
No HTML tags cluttering up the paragraphs, no deep nesting, It's mostly regular text.\
But when I _do_ need to insert some function calls, they effortlessly fall right in line with the writing flow. \
I vastly prefer this over Markdown + weird templating syntaxes. \

All hail Typst!


== I Need MOAR Experimental Features
Ok great, we have a language. \
Now I can harness its power to write my awesome blog, export it to html and publish!

Yeah, not quite.

See, HTML export in Typst is currently an early stage experimental feature.\
At the time of writing, they do have most of the native Typst-to-HTML element conversions figured out, see #link("https://github.com/typst/typst/issues/721")[here] but it's still quite buggy. \

One of the earliest bugs I found while writing my template was that Typst liked to sprinkle some `<p>` tags in the `<head>` element, which is only supposed to contain metadata, so the resulting HTML is invalid. \
I did #link("https://github.com/typst/typst/issues/7974")[report this], so if you're a time traveler from the future, hopefully it's already fixed for you! \
This had the nice effect of tripping up VSCode's live server extension, which I was using to preview the HTML page in real time. \
Luckily, switching to node's #link("https://github.com/tapio/live-server")[live-server] solved this problem for now.

That's just to preview a single page, though. \
Things spicier once I realized we need to build multiple pages at once. \
Think about it: a blog is (usually) more one page. We have need to have posts, index pages, about me, http error pages... all needing to be bundled alongside CSS styles and shared assets.

Here comes the kicker: Typst currently does *not* support multi-page compilation for non-paged export targets like HTML out of the box, at least not in any released version.

My immediate thought to fix this problem was the tried-and-true sledgehammer: I wrote a Makefile.

```Makefile
BLOG_SRC := content/
BLOG_DIST := dist/
POST_OUT_DIR := posts

POST_FOLDER_PREFIX := post-
POST_EXTENSION := typ

# Compile Typst Files
# Maps content/post-001/some-title.typ -> .dist/posts/001/some-title.html
POST_FILES := $(wildcard $(BLOG_SRC)$(POST_FOLDER_PREFIX)*/*.$(POST_EXTENSION))
HTML_FILES := $(patsubst $(BLOG_SRC)$(POST_FOLDER_PREFIX)%.$(POST_EXTENSION), $(BLOG_DIST)$(POST_OUT_DIR)/%.html, $(POST_FILES))

# Assets
# Maps content/post-001/assets/pic.jpg -> .dist/posts/001/assets/pic.jpg
ASSET_FILES := $(shell find $(BLOG_SRC) -path "*/assets/*" -type f 2>/dev/null)
ASSET_TARGETS := $(patsubst $(BLOG_SRC)$(POST_FOLDER_PREFIX)%, $(BLOG_DIST)$(POST_OUT_DIR)/%, $(ASSET_FILES))

# Styles
# Maps styles/blog.css -> .dist/styles/blog.css
STYLE_FILES := $(shell find styles -type f 2>/dev/null)
STYLE_TARGETS := $(patsubst styles/%, $(BLOG_DIST)styles/%, $(STYLE_FILES))

# Shared
# Maps shared/amogus.png -> .dist/shared/amogus.png
SHARED_FILES := $(shell find shared -type f 2>/dev/null)
SHARED_TARGETS := $(patsubst shared/%, $(BLOG_DIST)shared/%, $(SHARED_FILES))

.PHONY: all build clean copy-assets copy-styles serve

serve:
	live-server .dist & disown

# Main target
all: build copy-assets copy-styles copy-shared

build: $(HTML_FILES)

copy-assets: $(ASSET_TARGETS)

copy-styles: $(STYLE_TARGETS)

copy-shared: $(SHARED_TARGETS)

# --- Pattern Rules ---

# Rule for compiling Typst files
$(BLOG_DIST)$(POST_OUT_DIR)/%.html: $(BLOG_SRC)$(POST_FOLDER_PREFIX)%.$(POST_EXTENSION)
	@mkdir -p $(dir $@)
	typst compile $< $@ --root . --features html --format html

# Rule for copying post assets
$(BLOG_DIST)$(POST_OUT_DIR)/%: $(BLOG_SRC)$(POST_FOLDER_PREFIX)%
	@mkdir -p $(dir $@)
	cp $< $@

# Rule for copying styles
$(BLOG_DIST)styles/%: styles/%
	@mkdir -p $(dir $@)
	cp $< $@

# Rule for copying shared files
$(BLOG_DIST)shared/%: shared/%
	@mkdir -p $(dir $@)
	cp $< $@

clean:
	rm -rf $(BLOG_DIST)
```

Yeah, that's quite an abomination.

It works, sure, but it felt messy and distinctly not in spirit with my goal of having a fun, simple system. \
I wanted a clean setup, and this thing felt like the exact opposite.

I then decided to take a trip to the Typst repo, to see what the devs are up to. \

Lo and behold!\
A #link("https://github.com/typst/typst/pull/7964")[_massive_ PR] introducing exactly the kind of export bundling I needed had *just* been merged, roughly a couple days after I started writing this post!

Since it isn't released yet I immediatly cloned and built the git version of compiler myself. \
Hopefully I'll be able to also contribure some more bug reports, as a small thank you to the project. \

My project structure now looks as follows:

```text
blog/
├── src/
│   ├── posts/
│   │   ├── post-001.typ
│   │   └── post-002.typ
│   ├── shared/
│   ├── styles/
│   ├── blog-template.typ
│   ├── index.typ
│   └── utils.typ
├── dev.sh
└── dist.typ
```

There's a main `dist.typ` which acts as my central bundler file, an `index.typ` which acts as my temporary homepage, and `blog-template.typ` holding all the layout definitions.\
All the actual content goes into `src/posts/`.

I'm fully expecting this structure to change and evolve in the future as the blog grows, but for now, I'm finally happy with it.

To build the whole thing, I wrote a small Bash script that primarily launches the live server after the compilation's done, and shows me a QR code I can quickly scan with my phone to check how the page looks on mobile.

```bash
#!/bin/bash

# QR code generation using qrencode
qr() {
  local input
  if [[ -n "$1" ]]; then
    input="$*"
  else
    input="$(cat)"
  fi
  qrencode -t UTF8 -o - "$input"
}

# Fetch the local IP address
lanip() {
  ip -brief address show | grep -oP '192\.168\.\d+\.\d+' | head -n 1
}

# Watch, compile, and bundle via Typst
typst-git watch dist.typ \
  --root . \
  --format bundle \
  --features bundle,html \
  --ignore-system-fonts \
  --no-serve \
  --no-reload &

# Print QR code and start local server
qr http://$(lanip):8080
live-server ./dist
```

I'm using `typst-git watch` combined with the new `--format bundle` flag, which completely eliminates the need for separate manual file-copying steps. \
The background task handles all the compilation, and then `live-server` picks up the changes from `./dist` instantly.

The `qr` function is just a neat little trick to generate a scannable code in my terminal output using `qrencode`.

= Deploy and Enjoy
Alright, the site builds. Now I need to throw it onto the internet so someone can finally read it (hopefully ???). \
The obvious choice for a static site is GitHub Pages.\
It's free, it's fast, and it's _absolutely proprietary_.

I promise I will switch to self hosting. Learning to self host everything I need is one of the main reasons I Thought about opening this blog. To document my journey wiht it. \
But sadly, I have shaved enough yaks up until this point, so it's time to get this thing online, and think about proper self hosting later.

The workflow is simple: I run my build script locally, which spits out the final HTML and assets. I then commit that payload to a separate `publish` branch. GitHub Pages is configured to blindly serve whatever sits in the root of that branch.

== It's Alwasy DNS
I recently impulsively bought the `bulga.dev` domain on #link("https://porkbun.com/")[Porkbun], so the I'll set this blog to live at the `blog` subdomain. How creative. \
Setting up a custom domain on GitHub Pages shouldn't be too much of a hustle:
- You go to your profile settings > pages
- Input your custom domain
- You're given a TXT record to setup, GitHub will interrogate your domain, and when it responds with the expected token, your site is verified.

So I went ahead and created the following record through Porkbun:

#table(
  columns: 3,
  table.header([TYPE], [HOST], [ANSWER]),
  [TXT], [\_github-pages-challenge-bugg4.blog.bulga.dev], [_some-secret-value_],
)

- You then go into your repo's specific settings
- You set up the deplyment method for the site. I chose `deploy from branch`, chose `publish` as the branch and `/` as the root folder.
- You the input your desired custom domain, which visitors will get redirected to if they visit `your_username.github.io`
- You wait for GitHub to pass the DNS check on your domain, which may take from 2 to 786345 minutes.
- The DNS check fails

Wait what?
You didn't know? It's phisically impossible for anything remotely connected to DNS stuff to work succesfully on the first try. \
It's just how it works.

I hit the button again. \
GitHub ponders for another couple of minutes. \

Green checkmark, the DNS verification seemingly succeeded, but upon checking I was getting a fat 404 on my `bugg4.github.io` fallback URL. \
Turns out, because my repo is named `bulga-dev` and not exactly `bugg4.github.io`, GitHub treats it as a "Project Page". \
This means the default URL isn't the root, but rather `bugg4.github.io/bulga-dev/`. \
Whatever, the custom domain will hide that path anyway.

So I went into Porkbun, slapped `blog.bulga.dev` into a new CNAME record, pointed it to GitHub, and went to my repo settings to verify it.

GitHub spits back an `InvalidDNSError`. \
I stared at it. I mashed the "Check again" button. Nothing.

I then tried to query the DNS records myself using #link("https://github.com/ogham/dog")[dog]:

```sh
$ dog blog.bulga.dev.bulga.dev
Status: NXDomain
```

Wait. blog.bulga.dev.bulga.dev?

Yep. Porkbun, like many DNS managers, automatically appends your root domain to the Host field. \
By typing the full subdomain, I had unknowingly created a DNS record for a domain that sounded like I had a severe stutter.

I changed the Host field to just blog.

```Bash
marco@arch> dog blog.bulga.dev
CNAME blog.bulga.dev.    10m00s   "bugg4.github.io."
```

_Beautiful_

== The Caching Trap
I went back to GitHub, expecting a warm welcome.

`InvalidDNSError`.

🙃

Turns out, I was caught in the GitHub DNS Cache Trap. GitHub's massive global servers remember your mistakes and aggressively cache them. The only way to fix it was to remove the custom domain from GitHub's settings, walk away, make a coffee, question my life choices for 15 minutes, and then type it back in.

Finally, the DNS check turned green! \
I excitedly typed `blog.bulga.dev` into my browser and smashed Enter.

`net::ERR_CERT_COMMON_NAME_INVALID`

To keep my sanity intact, I threw a curl request at it:

```sh
$ curl blog.bulga.dev

<!DOCTYPE html>
<html lang="en">
  <head>
...
```
So blog _IS_ live.

So why was my browser having a panic attack?

I asked some clankers, and they came back with two main reasons:

+ The `.dev` Mandate: The `.dev` top-level domain is on the HSTS preload list. This means modern browsers physically refuse to load them over standard HTTP. They demand a secure HTTPS connection. curl worked because it doesn't care about browser security policies, but Brave absolutely does.

+ The Mismatched ID: GitHub hadn't finished provisioning my Let's Encrypt SSL certificate yet. When Brave demanded a secure connection, GitHub panicked and handed over its generic \*.github.io certificate. Brave saw that the names didn't match, assumed I was being hacked, and threw the error.

The solution? Wait harder.

I took the adivice, and after another 20 minutes, GitHub finally issued the certificate. \
I slammed that "Enforce HTTPS" checkbox in the repo settings, and the error finally went away.

We are live!

== Wrapping Up (And that ToC)
Oh, and remember that Table of Contents I talk about in the Python section? The one about needing to know the document structure before rendering the top of the page?

Typst handles it natively. You can just query the document for headings and it lists them automatically.

If you made it this far, thanks for reading my ramblings. \
\  Expect more posts about my current projects, obsessions and weird experiments, and probably more DNS-induced mental breakdowns as I plan to venture into self hosting _everything_.

#label(str(info.post_number))
