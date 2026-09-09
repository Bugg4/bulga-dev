
#import "../blog-template.typ": blog_post, kinds, styles, tags

#let info = (
  page_kind: kinds.post,
  main_title: "A Group of Cells Governed by Physics",
  subtitle: "A Bad Equation for Intelligence",
  author: "Marco Bulgarelli",
  date_published: datetime(day: 9, month: 9, year: 2026),
  read_time_mins: "10 min read",
  tags: (tags.ai, tags.philosophy),
  stylesheet: styles.blog,
  post_number: 3,
)

#show: blog_post.with(
  ..info,
)

= It Started With a Sunflower

This post started, as all rigorous scientific work does, in a WhatsApp argument after midnight.

We were talking about intelligence, and at some point my friend described a body as a group of cells governed by the laws of the world.

_The laws of physics_, I corrected him, with the confidence of someone about to turn a normal conversation into a philosophical hostage situation.

Plants came up. A root grows towards nutrients. A sunflower turns towards light. Does that make the plant intelligent?

His answer was no. The plant is following an algorithm encoded in its DNA.

Fair enough. But then the annoying question: *how is that fundamentally different from us?*

We also act according to structures encoded in biology, modified by experience, and executed by matter that follows physical laws. Our overall system is vastly larger and more adaptable, but its local rules may still be simple. Calling the plant "just an algorithm" does not tell us where intelligence begins. It only moves the mystery one step up the complexity ladder.

Somewhere between a root finding water, Stockfish finding checkmate, an LLM writing a paragraph, and a human asking why any of this counts, we decide to use the word _intelligence_.

Where, exactly, should we draw the line?

= Intelligence Without Magic

I tend to take a functionalist view of this stuff: judge a system by what it can do, not by what it is made of.

Computation is not a property exclusive to silicon. You can encode an algorithm in a mechanical device, in flowing water, in air pressure, in transistors, or in cells. Once a system can receive input, transform information, and produce output, it can execute an algorithm. The substrate changes what is practical, not what computation fundamentally is.

This is not the same as claiming that every useful algorithm is conscious, alive, or secretly having feelings. Intelligence and consciousness are separate questions, and mixing them makes both conversations worse.

The narrower question is this: *what makes a system capable of turning information into useful decisions in situations it has not encountered exactly before?*

"Humans can generalize" sounds like a promising answer until machines start doing it too.

An LLM can write a sentence absent from its training data, adapt an explanation to a new audience, or combine concepts into a solution it was never explicitly given. You can argue about how well it does these things, but saying it cannot generalize at all requires a definition carefully constructed to exclude it.

The usual retreat is that machine generalization is "algorithmic," while human generalization is unpredictable and unique.

But our brains are physical systems too. If unpredictability is the magic ingredient, is it a property of intelligence or merely a property of our inability to measure and control all the variables?

= My Extremely Scientific Equation

I tried to compress the idea into a deliberately crude model:

`intelligence ~= data scale * inference speed * algorithmic complexity + entropy`

This is not a measurable law. I do not have units for "algorithmic complexity," and I would be extremely suspicious of anyone selling an intelligence benchmark based on this formula. It is a thinking tool: four knobs that seem to shape the behaviour we call intelligent.

The multiplication is the important part. None of these ingredients is intelligent in isolation. A universe of data sitting untouched does nothing. The most elaborate function in existence does nothing if it receives no input and is never executed. Intelligence, if it appears, appears in the interaction: a process operating on information at sufficient scale.

== Data Scale

A system needs something to reason _with_: observations, memories, training examples, inherited structure, or the current state of its environment.

"Data" here is broader than files in a dataset. For a human it includes a lifetime of sensory experience, language, culture, bodily feedback, and perhaps useful priors produced by evolution. For a plant it includes chemical gradients, light, gravity, moisture, and whatever state its biology retains. For an LLM it includes training data and the tokens currently in context.

No input, no experience, no useful model of the world.

== Inference Speed

Having information is not enough. A system must transform it quickly enough for the problem it inhabits.

A perfect chess move calculated after the heat death of the universe is not very useful. Neither is a root that identifies water only after the plant has dried out.

Speed is relative to the environment. Human neurons are laughably slow next to silicon, yet our brains process enough signals in parallel to steer a body through a changing world in real time.

== Algorithmic Complexity

By this I mean the richness of the process connecting input to action: how many kinds of relationships it can represent, how deeply it can compose them, and how flexibly it can reuse what it has learned.

I do not mean that every individual instruction must be impressive. At the lowest useful level, a neuron might be described as receiving electrochemical signal X and sending signal Y. An LLM mostly performs matrix multiplications. Neither operation looks remotely like thought when inspected alone.

What changes is the scale at which those operations are connected: the number of neurons or parameters, the number of relationships between them, the speed of their interaction, and the size of the solution space the resulting system can navigate. That space may be effectively unbounded even when each step through it is mechanically simple. Thought is not hiding inside one special instruction; it emerges from the organisation and scale of the whole computation.

A thermostat has data, performs inference quickly, and makes decisions. Its algorithm is simply too narrow for us to call it intelligent in ordinary conversation.

This is also where the word "algorithm" stops being a dismissal. A process does not become unintelligent just because we can describe its rules. If that were true, understanding the brain would retroactively abolish human intelligence.

== Entropy

Entropy was the part that caused the argument.

I was using the word loosely to mean the variability a system cannot perfectly eliminate: noise in its environment, stochastic exploration, microscopic fluctuations, and all the disturbances that keep two apparently identical situations from unfolding identically.

Variability lets a system explore alternatives rather than always falling into the same path. Too little can make behaviour rigid. Too much gives you noise rather than thought. The useful quantity is not maximum entropy, but enough variation to escape a single groove while preserving structure.

And this is where my neat equation starts to break.

= Four Very Different Thinkers

Consider four systems through this framework.

== A Plant

A plant has limited but continuous environmental data, slow inference on our timescale, specialised biological mechanisms, and plenty of physical variability.

It senses, communicates internally, adapts, and solves a narrow set of survival problems. Calling this intelligence may feel wrong, but it is at least on the same continuum. The disagreement is partly about where we choose to place a threshold.

== Stockfish

Stockfish is extremely fast, sophisticated within its domain, and effectively deterministic when its configuration and execution are fixed. Compared with a general model, the information it consumes at decision time is tiny: a board position and a bounded search history.

It is superhuman at chess and helpless outside it. That is why "narrow AI" is a useful label. Stockfish demonstrates that a deterministic system can display extraordinary competence. It also demonstrates that competence in one search space is not the same as general intelligence.

Still, _narrow_ intelligence is not _no_ intelligence. Optimise a system enough to navigate an enormous space of chess positions and it acquires at least one characteristic we recognise as intelligent: it solves a difficult problem. Ask it about tomorrow's weather and it has nothing to say, not because its chess ability was fake, but because generality was never its function.

== An LLM

An LLM has absorbed an enormous scale of data, runs inference quickly, and uses an architecture whose basic operation is surprisingly uniform compared with the complexity of its output. Its decoding entropy is adjustable.

Turn the temperature up and it samples less likely tokens, producing more varied and often more creative paths. Turn it down to zero and decoding normally selects the most likely token at every step.

The model does not suddenly lose everything it learned at temperature zero. It can still answer a new question, transform unseen text, and apply patterns to a fresh context. In other words, it can still generalize.

Strict reproducibility is messier in practice. GPU arithmetic, kernel execution order, batching, quantization, and tiny floating-point differences can change logits between runs. But if the model, input, arithmetic, execution order, hardware behaviour, and greedy decoder are all fixed, transformer inference can be deterministic. There is nothing intrinsically random about its forward pass.

I #link("https://chatgpt.com/share/6aa093e8-cf18-83eb-b74d-a0713cc85730?ogimg=plain")[checked this after the argument], expecting a clean yes or no, and instead found three useful meanings of "deterministic": deterministic token selection, reproducible runs, and bit-for-bit identical computation. Temperature zero normally gives you the first. The other two depend on how tightly you control the inference stack.

This matters because it separates two ideas I had initially bundled together: *intelligence can be deterministic; exploration does not have to be*.

== A Human

Humans combine an enormous stream of experience with a biological algorithm we barely understand. Our raw calculation speed is mediocre, our parallelism is excellent, and the entropy of our bodies and environments is not exposed as a convenient slider.

Ask a person the same question twice and the answers may differ. Their internal state has changed. They have read the question once already. Their attention moved, a memory surfaced, a neuron fired differently, or they just became more annoyed with you.

That variability may be useful. It may even be necessary for the kind of open-ended intelligence we exhibit. But unpredictability alone cannot prove that human thought belongs to a different metaphysical category. A roulette wheel is unpredictable too, and nobody asks it for career advice.

= The Formula Needs a Patch

My first intuition was that if any of the four terms approached zero, intelligence should approach zero with it. Stockfish and deterministic LLM inference make that difficult to defend for entropy.

A better version is:

`capacity ~= data scale * inference speed * algorithmic expressiveness`

Entropy then changes how that capacity is explored. It can increase novelty, adaptability, and the chance of leaving a local optimum, but it is not a substitute for information or structure. It behaves less like fuel and more like turbulence: sometimes essential, sometimes useful, sometimes destructive.

This also suggests there is no single intelligence scalar. We compress a landscape of abilities into one flattering word. Chess search, language modelling, plant adaptation, and human reasoning occupy different shapes in that landscape. "Is it intelligent?" may be less useful than asking:

- What information can it perceive and retain?
- What transformations can it perform?
- How quickly can it act relative to its environment?
- How far outside a familiar situation can it generalize?
- Does variability help it explore, or merely corrupt its output?

= No Escape Through Free Will

Eventually the conversation arrived at free will, because apparently we were determined to get no sleep.

If we had complete knowledge and control of physics, would a human thought be predictable? In a perfect simulation of the universe, could the simulator know my next sentence before I write it?

I suspect yes. My friend argued that physics is above us and outside our control, so we cannot be deterministic from our own point of view.

Those claims may both be true. A system can be deterministic in principle and impossible to predict from inside itself. Determinism does not imply practical predictability, and unpredictability does not establish free will.

Maybe to a sufficiently capable observer we would look like LLMs: huge state-transition systems, shaped by training data we call experience, producing outputs whose causes are too numerous for us to inspect.

That idea does not make humans less intelligent. It just removes one of the comforting ways we make our intelligence special.

= So, When Is a System Intelligent?

I still do not have a clean threshold, and I increasingly suspect there is not one.

It is the old question of the heap: how many grains of sand do you need before they stop being separate grains and become a pile? One grain obviously is not a heap. Ten thousand obviously are. Demanding the exact grain that performs the transformation does not improve our understanding of sand.

The boundary between a mechanism and an intelligent system may work the same way. A tiny input space and a tiny function look like a reflex. Push the data, connectivity, speed, and reachable solutions far enough and the combined system begins to look intelligent. The precise point where we switch words matters less than understanding what changed along the way.

Intelligence looks less like a substance a system possesses and more like a relationship between its machinery, its information, and the problems around it. A sunflower is well adapted to its world. Stockfish is godlike in a tiny universe. An LLM ranges across a much larger symbolic space, with strange blind spots. A human combines language, memory, embodiment, social learning, and continuous feedback into something broader again.

The differences are real. They may be differences of architecture, scale, embodiment, adaptability, or degree. We should investigate them instead of hiding them behind the word "just."

_Just_ an algorithm. _Just_ statistics. _Just_ a group of cells governed by physics.

"Just" is doing all the work.

For now, my best answer is this: a system is intelligent when it can use information to produce useful behaviour across enough variation that a simple reflex no longer explains it well.

The boundary will move as our machines improve and as we understand biology better. That is fine. The point of a definition is not to protect our ego. It is to help us see what different systems are actually doing.

And whatever conclusion we reach, goodnight, little cell. You are still governed by physics.
