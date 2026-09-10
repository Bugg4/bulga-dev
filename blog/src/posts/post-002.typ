
#import "../blog-template.typ": blog_post, kinds, styles, tags

#let info = (
  page_kind: kinds.post,
  main_title: "My Coding Setup",
  subtitle: "My LLM Wrote This Subtitle While I Got Paid For It",
  author: "Marco Bulgarelli",
  date_published: datetime(day: 20, month: 07, year: 2026),
  read_time_mins: "5 min read",
  tags: (tags.vibecoding,),
  stylesheet: styles.blog,
  post_number: 2,
)

#show: blog_post.with(
  ..info,
)

= Back Again
Back again throwing bytes on the interwebz.

Wait, you thought I was gonna continue with the self-hosting projects I mentioned I had planned in my first post?
Yeah, well... the ADHD monster took over, you're gonna have to get used to it, never trust what I say I'll do next!

== Why am I Writing Here Again ...?
Anyway I just wanted to write a couple lines to document how I program day to day in this not so new LLM dominated landscape.

I recently found a workflow I'm pretty happy with, and I figured it'd be interesting to freeze it in writing while it's still fresh.

== To Vibe or Not to Vibe
Look, I'm not here to debate whether AI-assisted coding is good or bad. That horse has been beaten to a fine paste already.

I _will_ say that Linus Torvalds' recent take gave me a chuckle: #link("https://lore.kernel.org/linux-media/CAHk-=wi4zC+Ze8e+p3tMv8TtG_80KzsZ1syL9anBtmEh5Z40vg@mail.gmail.com/")[when asked about AI-generated kernel patches], his response was essentially "if you're anti-AI, just fork the kernel."

What I _will_ also say is that once you've experienced an LLM following your exact instructions to the letter while you sip your coffee, going back feels genuinely suboptimal.

I've heard every opinion on vibecoding under the sun. It's the death of software engineering. It's the greatest productivity leap since Stack Overflow. It'll make juniors never learn fundamentals. It'll let seniors 10x their output. It's a crutch. It's a superpower.

Here's my take: it's a tool. Use it well, it amplifies you. Use it poorly, it amplifies your bad habits. Same as any tool we've ever adopted.

I see myself as a fucntionalist at heart. Take something for what it does, not for what it is.

The _actual_ problem, as far as I'm concerned, isn't AI coding itself, it's the harness. Everything I tried was either:
- Tied to a specific editor (looking at you, Cursor),
- Wrapped in a clunky web UI (looking at you, ChatGPT),
- Or built by companies that will probably pivot to crypto any day now, or just sell out to ClosedAI.

Enter OpenCode.

== Opencode: The Missing Piece
#link("https://github.com/anomalyco/opencode")[Opencode] is an open-source CLI coding agent.
You install it, you run it in your terminal, and it has access to your filesystem, your shell, your git repo — the whole shebang.

What sold me on opencode over alternatives like Claude Code or Aider is that it's truly editor-agnostic.
It lives in your terminal, period.
It doesn't care if you use VSCode, Neovim, Emacs, or ed (you freak).

Here's my typical flow:

+ I have VSCode open for browsing, editing, and understanding the codebase.
+ I have opencode running in the integrated terminal, waiting for instructions.
+ I describe what I want, opencode goes off and does it, I review the diff, I tweak what I don't like, I commit.

That's it. Two windows, one brain (the LLM's, mostly).

I run VSCode basically vanilla, just the editor doing editor things, and the agent doing agent things.

== The Two Plugins
Opencode is extensible through plugins and MCP servers. Here's what I'm running:

=== DCP — Dynamic Context Pruning
#link("https://github.com/Opencode-DCP/opencode-dynamic-context-pruning")[DCP] is a context management plugin that automatically compresses older parts of the conversation to keep the context window lean.

If you've used any LLM coding tool for more than five minutes, you know the pain: the agent starts strong, then gradually loses its mind as the conversation grows, forgetting what you told it three messages ago and suggesting solutions you already rejected.
DCP mitigates this by intelligently summarizing stale context, so the agent stays lucid for longer sessions.

Is it perfect? No. Sometimes it compresses something you still needed, and you have to remind the agent what's going on.
But it's a hell of a lot better than the alternative, which is hitting the context limit and watching your agent devolve into a confused parrot.

=== ADtention — Get Paid to Watch Your Agent Work
#link("https://adtention.ai/")[ADtention] is delightfully simple: it adds a single sponsor line to the bottom of your opencode terminal, and you earn a small amount every time it refreshes.

No popups, no banners, no obnoxious interruptions. Just one quiet line sitting in the TUI footer while your agent churns through your prompts.

Now, I know what you're thinking. _"An ad plugin reading my code? Hard pass."_ \
I thought the same thing. But here's the clever part: the categorization happens entirely on your machine.

When you send a prompt, the plugin looks at the _kinds_ of files in your project and sorts it into one of six broad buckets — `web`, `web3`, `devops`, `data`, `systems`, or `general`. That single word is the only thing that leaves your machine, along with a random install ID (a pseudonym, not tied to any personal data). The server uses it to pick a relevant sponsor and credit your balance.

No code, no file contents, no prompts, no replies, no file names or repo names — nothing identifying leaves your box. \
The whole plugin is one readable file. You can audit it in five minutes.

I'm not making any meaningful money from this (yet), but the idea of getting paid literal cents while my agent writes boilerplate I was gonna write anyway is kind of hilarious.
Also the running balance at the bottom-right of the terminal scratches a very specific dopamine itch. Number go up. brain happy.

If you're running opencode, just `opencode plugin @adtention/opencode` and you're set.

== MCPs: Giving the Agent Superpowers
Right, so what the hell are MCPs?

MCP stands for Model Context Protocol. It's an open standard (by Anthropic, but anyone can implement it) that lets LLMs interact with external tools and data sources in a structured way.
Think of it as a universal adapter between an AI agent and... basically anything. Databases, APIs, file systems, PDF readers — if someone wrote an MCP server for it, your agent can talk to it.

For opencode, MCPs show up as additional tools the agent can invoke.
This means instead of telling opencode "here's a SQL file, figure out what's in my database", I can just give it direct database access and say "hey, check if this migration will break anything".

Here's what I'm running:

=== Postgres MCP
I work with PostgreSQL a lot. Having an MCP that lets the agent run read-only queries, inspect schemas, and analyze query plans directly is a massive time saver.
Instead of copy-pasting table definitions and sample data into the chat, opencode can just... look.
It can verify its assumptions, check if a column exists before generating code, and even suggest indexes based on actual query patterns.

=== MongoDB MCP
Yes, I also use MongoDB. No, I don't want to talk about it.
Some of us don't get to choose our tech stack at work, okay?
The MongoDB MCP serves the same purpose as the Postgres one — it gives the agent direct, structured access to collections so it can explore data shapes without me having to describe them in painstaking detail.

=== PDF Reader MCP
This one is actually my favorite. It lets opencode read PDF files: extracting text, tables, metadata, even running OCR on scanned pages.
Sounds simple, but it's the best skill you can give to your agent.
I use it mostly for work documentation that only exists as PDFs (you know the type: 200-page technical specs that someone exported from Confluence in 2019 and nobody has touched since).
Instead of skimming through it myself, I can ask opencode "find me the section about authentication flow" and it just... does it.

Between these three, the agent has pretty good awareness of my data and my docs.
It's not quite Jarvis, but we're getting there.

== Where This Is Going
I'm still figuring out the optimal setup. The combination of vanilla VSCode + opencode + MCPs has been working surprisingly well for the past few weeks, but I'm constantly tweaking.

Until next time.\
_May your context window be large and your hallucinations minimal._
