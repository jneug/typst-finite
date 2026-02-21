
#import "@preview/mantys:1.0.2": *

#import "../src/finite.typ" as finite: cetz

#import "../src/util.typ"

// Customize the show-module function
#let show-module(
  name,
  scope: (:),
  outlined: false,
  ..tidy-args,
) = tidy-module(
  name,
  read("../src/" + name + ".typ"),
  show-outline: outlined,
  // scope: scope,
  // include-examples-scope: true,
  // extract-headings: 3,
  ..tidy-args,
)

// Nice display of CeTZ commands
#show "CETZ": _ => package[CeTZ]
#let cetz-cmd = cmd.with(module: "cetz")
#let cetz-cmd- = cmd-.with(module: "cetz")
#let cetz-draw = cmd.with(module: "cetz.draw")
#let cetz-draw- = cmd-.with(module: "cetz.draw")

#show: mantys(
  ..toml("../typst.toml"),

  title: align(
    center,
    image("assets/finite-logo.svg", width: 100%),
  ),

  date: datetime.today(),
  abstract: [
    FINITE is a Typst package to draw transition diagrams for finite automata (finite state machines) with the power of CETZ.

    The package provides commands to quickly draw automata from a transition table but also lets you manually create and customize transition diagrams on any CETZ canvas.
  ],

  examples-scope: (
    scope: (
      cetz: cetz,
      finite: finite,
      util: util,
      automaton: finite.automaton,
    ),
  ),

  theme: themes.modern,

  git: git-info(file => read(file)),

  assets: (
    "assets/finite-logo.svg": "assets/finite-logo.typ",
  ),
)

= Usage <sec:usage>

== Importing the package <subsec:importing>

Import the package in your Typst file:

#show-import(imports: "automaton")

== Manual installation <subsec:manual-install>

The package can be downloaded and saved into the system dependent local package repository.

Either download the current release from #github("jneug/typst-finite") and unpack the archive into your system dependent local repository folder#footnote[#std.link("https://github.com/typst/packages#local-packages")] or clone it directly:

#show-git-clone()

In either case, make sure the files are placed in a subfolder with the correct version number: #context document.use-value("package", p => raw(block: false, p.name + "/" + str(p.version)))

After installing the package, just import it inside your `typ` file:

#show-import(repository: "@local", imports: "automaton")

== Dependencies <subsec:dependencies>

FINITE loads #link("https://github.com/johannes-wolf/typst-canvas")[CETZ] and the utility package #link("https://github.com/jneug/typst-tools4typst")[#package[t4t]] from the `preview` package repository. The dependencies will be downloaded by Typst automatically on first compilation.

#custom-type("coordinate", color: silver)Whenever a #dtype("coordinate") type is referenced, a CETZ coordinate can be used. Please refer to the CETZ manual for further information on coordinate systems.

= Drawing automata <sec:drawing>

FINITE helps you draw transition diagrams for finite automata in your Typst documents, using the power of CETZ.

To draw an automaton, simply import #cmd[automaton] from FINITE and use it like this:
#example[```typ
#automaton((
  q0: (q1:0, q0:"0,1"),
  q1: (q0:(0,1), q2:"0"),
  q2: none,
))
```]

As you can see, an automaton is defined by a dictionary of dictionaries. The keys of the top-level dictionary are the names of states to draw. The second-level dictionaries use the names of connected states as keys and transition labels as values.

In the example above, the states `q0`, `q1` and `q2` are defined. `q0` is connected to `q1` and has a loop to itself. `q1` transitions to `q2` and back to `q0`. #cmd-[automaton] selected the first state in the dictionary (in this case `q0`) to be the initial state and the last (`q2`) to be a final state.

See @aut-specs for more details on how to specify automata.

To modify the layout and style of the transition diagram, #cmd-[automaton] accepts a set of options:
#example(breakable: true)[```typ
#automaton(
  (
    q0: (q1:0, q0:"0,1"),
    q1: (q0:(0,1), q2:"0"),
    q2: (),
  ),
  initial: "q1",
  final: ("q0", "q2"),
  labels:(
    q2: "FIN"
  ),
  style:(
    state: (fill: luma(248), stroke:luma(120)),
    transition: (stroke: (dash:"dashed")),
    q0-q0: (anchor:top+left),
    q1: (initial:top),
    q1-q2: (stroke: 2pt + red)
  )
)
```]

For larger automata, the states can be arranged in different ways:
#example(breakable: true)[```typ
#let aut = (:)
#for i in range(10) {
  let name = "q"+str(i)
  aut.insert(name, (:))
  if i < 9 {
    aut.at(name).insert("q" + str(i + 1), none)
  }
}
#automaton(
  aut,
  layout: finite.layout.circular.with(offset: 45deg),
  style: (
    transition: (curve: 0),
    q0: (initial: top+left)
  )
)
```]

See @using-layout for more on layouts.

== Specifying finite automata <aut-specs>

Most of FINITE's commands expect a finite automaton specification ("@type:spec" in short) as the first argument. These specifications are dictionaries defining the elements of the automaton.

If an automaton has only one final state, the spec can simply be a @type:transition-table. In other cases, the specification can explicitly define the various elements.

#custom-type("transition-table", color: rgb("#57a0be"))
A transition table is a #typ.t.dict with state names as keys and dictionaries as values. The nested dictionaries have state names as keys and the transition inputs / labels as values.

#codesnippet[```typc
(
  q0: (q1: (0, 1), q2: (0, 1)),
  q1: (q1: (0, 1), q0: 0, q2: 1),
  q2: (q0: 0, q1: (1, 0)),
)
```]

#custom-type("spec", color: rgb("#76d6ff"))
A specification (@type:spec) is composed of these keys:
```typc
(
  transitions: (...),
  states: (...),
  inputs: (...),
  initial: "...",
  final: (...),
  labels: (...),
  input-labels: (...)
)
```

- `transitions` is a dictionary of dictionaries in the format:
  ```typc
  (
    state1: (input1, input2, ...),
    state2: (input1, input2, ...),
    ...
  )
  ```
- `states` is an optional array with the names of all states. The keys of `transitions` are used by default.
- `inputs` is an optional array with all input values. The inputs found in `transitions` are used by default.
- `initial` is an optional name of the initial state. The first value in `states` is used by default.
- `final` is an optional array of final states. The last value in `states` is used by default.
- `labels` is a dictionary mapping state and transition names to display labels. An empty dictionary by default.
- `input-labels` is a dictionary mapping input strings to display content. An empty dictionary by default. Inputs that are themselves content values are automatically added here.

The utility function #cmd(module: "util")[create-automaton] can be used to create a full spec from a partial dictionary by filling in the missing values with the defaults.

=== Input labels <input-labels>

By default, transition labels use the raw input strings or numbers from the transition table. The #arg[input-labels] parameter of #cmd[automaton] (and #cmd[create-automaton]) lets you map those raw inputs to arbitrary content — useful for Greek letters, mathematical symbols, or any formatted text.

#example[```typ
#automaton(
  (q0: (q1: "e"), q1: (q2: "l"), q2: none),
  input-labels: (
    e: $epsilon$,
    l: $lambda$,
  )
)
```]

Input labels are stored in the spec under the `input-labels` key and are used both in transition diagrams and in #cmd[transition-table] column headers. Inputs that are themselves content values (rather than strings or numbers) are automatically recorded as their own labels.

#info-alert[
  Input labels affect display only. The raw input strings (e.g. `"e"`, `"l"`) are still used internally by #cmd[accepts] and other simulation functions.
]

== Command reference
#show-module("cmd", sort-functions: false)

== Styling the output

As common in CETZ, you can pass general styles for states and transitions to the #cetz-cmd-[set-style] function within a call to #cetz-cmd-[canvas]. The element functions #cmd-[state] and #cmd-[transition] (see below) can take their respective styling options as arguments to style individual elements.

#cmd[automaton] takes a #arg[style] argument that passes the given style to the above functions. The example below sets a background and stroke color for all states and draws transitions with a dashed style. Additionally, the state `q1` has the arrow indicating an initial state drawn from above instead of from the left. The transition from `q1` to `q2` is highlighted in red.
#example(breakable: true)[```typ
#automaton(
  (
    q0: (q1:0, q0:"0,1"),
    q1: (q0:(0,1), q2:"0"),
    q2: (),
  ),
  initial: "q1",
  final: ("q0", "q2"),
  style:(
    state: (fill: luma(248), stroke:luma(120)),
    transition: (stroke: (dash:"dashed")),
    q1: (initial:top),
    q1-q2: (stroke: 2pt + red)
  )
)
```]

Every state can be accessed by its name and every transition is named with its initial and end state joined with a dash (`-`), for example `q1-q2`.

The supported styling options (and their defaults) are as follows:
- states:
  / #arg(fill: auto): Background fill for states.
  / #arg(stroke: auto): Stroke for state borders.
  / #arg(radius: .6): Radius of the states circle.
  / #arg(extrude: .88):
  - `label`:
    / #arg(text: auto): State label.
    / #arg(size: 1em): Initial text size for the labels (will be modified to fit the label into the state's circle).
    / #arg(fill: none): Color of the label text.
    / #arg(padding: auto): Padding around the label.
  - `initial`:
    / #arg(anchor: auto): Anchorpoint to point the initial arrow to.
    / #arg(label: auto): Text above the arrow.
    / #arg(stroke: auto): Stroke for the arrow.
    / #arg(scale: auto): Scale of the arrow.
- transitions
  / #arg(curve: 1.0): "Curviness" of transitions. Set to #value(0) to get straight lines.
  / #arg(stroke: auto): Stroke for transition lines.
  - `label`:
    / #arg(text: ""): Transition label.
    / #arg(size: 1em): Size for label text.
    / #arg(fill: none): Color for label text. When set to #value(none), the color is inherited from the transition's stroke color.
    / #arg(
        pos: .5,
      ): Position on the transition, between #value(0) and #value(1). #value(0) sets the text at the start, #value(1) at the end of the transition.
    / #arg(dist: .33): Distance of the label from the transition.
    / #arg(angle: auto): Angle of the label text. #value(auto) will set the angle based on the transitions direction.

== Using #cmd-(module: "cetz")[canvas]

The above commands use custom CETZ elements to draw states and transitions. For complex automata, the functions in the #module[draw] module can be used inside a call to #cetz-cmd-[canvas].
#example(breakable: true)[```typ
#cetz.canvas({
  import cetz.draw: set-style
  import finite.draw: state, transition

  state((0,0), "q0", initial:true)
  state((2,1), "q1")
  state((4,-1), "q2", final:true)
  state((rel:(0, -3), to:"q1.south"), "trap", label:"TRAP", anchor:"north-west")

  transition("q0", "q1", inputs:(0,1))
  transition("q1", "q2", inputs:(0))
  transition("q1", "trap", inputs:(1), curve:-1)
  transition("q2", "trap", inputs:(0,1))
  transition("trap", "trap", inputs:(0,1))
})
```]

=== Element functions
#show-module("draw", sort-functions: false)

=== Anchors

States and transitions are created in a #cetz-draw[group]. States are drawn with a circle named `state` that can be referenced in the group. Additionally, they have a content element named `label` and optionally a line named `initial`. These elements can be referenced inside the group and used as anchors for other CETZ elements. The anchors of `state` are also copied to the state group and are directly accessible.

#info-alert[
  That means setting #arg(anchor: "west") for a state will anchor the state at the `west` anchor of the state's circle, not of the bounding box of the group.
]

Transitions have an `arrow` (#cetz-draw[line]) and `label` (#cetz-draw[content]) element. The anchors of `arrow` are copied to the group.

#example(breakable: true)[```typ
#cetz.canvas({
  import cetz.draw: circle, line, content
  import finite.draw: state, transition

  let magenta = rgb("#dc41f1")

  state((0, 0), "q0")
  state((4, 0), "q1", final: true, stroke: magenta)

  transition("q0", "q1", label: $epsilon$)

  circle("q0.north-west", radius: .4em, stroke: none, fill: black)

  let magenta-stroke = 2pt + magenta
  circle("q0-q1.label", radius: .5em, stroke: magenta-stroke)
  line(
    name: "q0-arrow",
    (rel: (.6, .6), to: "q1.state.north-east"),
    (rel: (.1, .1), to: "q1.state.north-east"),
    stroke: magenta-stroke,
    mark: (end: ">"),
  )
  content(
    (rel: (0, .25), to: "q0-arrow.start"),
    text(fill: magenta, [*very important state*]),
  )
})
``` ]

== Layouts <using-layout>

#error-alert[
  Layouts changed in FINITE version 0.5 and are no longer compatible with FINITE 0.4 and before.
]

Layouts can be passed to @cmd:automaton to position states on the canvas without the need to give specific coordinates for each state. FINITE ships with a bunch of layouts, to accommodate different scenarios.

=== Available layouts <available-layouts>
#show-module("layout", sort-functions: false)

== Utility functions
#show-module("util", outlined: true)

= Simulating input

FINITE has a set of functions to simulate, test and view finite automata.

== Testing word acceptance <simulating-accepts>

The #cmd[accepts] function tests whether a given word is accepted by an automaton. It takes a @type:spec or @type:transition-table as its first argument and a word as a #typ.t.str.

If the word is rejected, #cmd[accepts] returns #value(false). If accepted, it returns formatted content showing the path of states and transitions that led to acceptance.

#example[```typ
#let aut = (
  q0: (q1: "0"),
  q1: (q1: "0", q2: "1"),
  q2: none
)

Accepted: #finite.accepts(aut, "01")

Rejected: #repr(finite.accepts(aut, "10"))
```]

If the automaton has no final states, #cmd[accepts] returns #value(false) for every word without an error.

#example[```typ
#let no-final = finite.create-automaton(
  (q0: (q0: "0", q1: "1"), q1: (q0: "1", q1: "0")),
  final: none
)
#repr(finite.accepts(no-final, "01"))
```]

The output of #cmd[accepts] uses the `input-labels` stored in the spec for display. To see labels in the acceptance path, first build a spec with #cmd[create-automaton] and the #arg[input-labels] parameter:

#example[```typ
#let spec = finite.create-automaton(
  (q0: (q1: "e"), q1: (q2: "l"), q2: none),
  input-labels: (e: $epsilon$, l: $lambda$)
)
#finite.accepts(spec, "el")
```]

#info-alert[
  The #arg[word] argument of #cmd[accepts] is always a plain #typ.t.str using the raw input keys (e.g. `"e"`, `"l"`), not the display labels.
]

= FLACI support

FINITE was heavily inspired by the online app #link("https://flaci.org", "FLACI"). FLACI lets you build automata in a visual online app and export your creations as JSON files. FINITE can import these files and render the result in your document.

#warning-alert[FINITE currently only supports DEA and NEA automata.]

#example[```typ
  #finite.flaci.automaton(read("flaci-export.json"))
```][
  #finite.flaci.automaton(read("assets/flaci-export.json"))
]

#warning-alert[
  *Important* \
  Read the FLACI json-file with the #typ.read function, not
  the #typ.json function. FLACI exports automata with a wrong encoding
  that prevents Typst from properly loading the file as JSON.
]

=== FLACI functions
#show-module("flaci", module: "flaci", sort-functions: false)

// = Working with grammars

= Doing other stuff with FINITE

Since transition diagrams are effectively graphs, FINITE could also be used to draw graph structures:
#example[```typ
#cetz.canvas({
  import cetz.draw: set-style
  import finite.draw: state, transitions

  state((0,0), "A")
  state((3,1), "B")
  state((4,-2), "C")
  state((1,-3), "D")
  state((6,1), "E")

  transitions((
      A: (B: 1.2),
      B: (C: .5, E: 2.3),
      C: (B: .8, D: 1.4, E: 4.5),
      D: (A: 1.8),
      E: (:)
    ),
    C-E: (curve: -1.2))
})
```]

= Showcase <sec:showcase>

#example(breakable: true)[```typ
#scale(80%, automaton((
    q0: (q1: 0, q2: 0),
    q2: (q3: 1, q4: 0),
    q4: (q2: 0, q5: 0, q6: 0),
    q6: (q7: 1),
    q1: (q3: 1, q4: 0),
    q3: (q1: 1, q5: 1, q6: 1),
    q5: (q7: 1),
    q7: ()
  ),
  layout: finite.layout.group.with(grouping: (
      ("q0",),
      ("q1", "q2", "q3", "q4", "q5", "q6"),
      ("q7",)
    ),
    spacing: 2,
    layout: (
      finite.layout.custom.with(positions: (q0: (0, -2))),
      finite.layout.grid.with(columns:3, spacing:2.6, position: (2, 1)),
      finite.layout.custom.with(positions: (q7: (8, 6)))
    )
  ),
  style: (
    transition: (curve: 0),
    q1-q3: (curve:1),
    q3-q1: (curve:1),
    q2-q4: (curve:1),
    q4-q2: (curve:1),
    q1-q4: (label: (pos:.75)),
    q2-q3: (label: (pos:.75, dist:-.33)),
    q3-q6: (label: (pos:.75)),
    q4-q5: (label: (pos:.75, dist:-.33)),
    q4-q6: (curve: 1)
  )
))
```]
