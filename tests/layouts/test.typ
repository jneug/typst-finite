#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

#let aut = range(6).fold(
  (:),
  (d, i) => {
    d.insert("q" + str(i), ())
    d
  },
)
#let spec = finite.create-automaton(aut)

=== layout.custom
#finite.automaton(
  aut,
  layout: (
    q0: (0, 0),
    q1: (4, 0),
    q2: (rel: (0, -3)),
    q3: (rel: (-1, -3), to: "q0"),
    rest: (rel: (2, -2)),
  ),
)

#pagebreak()

=== layout.linear
#finite.automaton(
  aut,
  layout: finite.layout.linear,
)

#pagebreak()
=== layout.circular
#finite.automaton(
  aut,
  layout: finite.layout.circular.with(offset: 30deg),
  style: (state: (radius: .8), q1: (radius: 1)),
)

#pagebreak()
=== layout.grid
#finite.automaton(
  aut,
  layout: finite.layout.grid,
)

#pagebreak()
=== layout.snake
#finite.automaton(
  aut,
  layout: finite.layout.snake,
)

#pagebreak()
=== layout.group
#finite.automaton(
  aut,
  layout: finite.layout.group.with(
    grouping: 4,
    spacing: 2,
    layout: (
      finite.layout.circular.with(radius: 8),
      finite.layout.linear.with(dir: top),
    ),
  ),
)
