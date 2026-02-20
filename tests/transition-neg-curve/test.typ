#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

#finite.automaton(
  initial: none,
  final: none,
  (q1: (q2: none), q2: (q1: none)),
  style: (
    transition: (curve: -1),
  ),
)

#pagebreak()

#finite.cetz.canvas({
  import finite.draw: state, transition

  state((0, 0), "q1")
  state((2.4, 0), "q2")

  transition("q1", "q2", curve: -1)
  transition("q2", "q1", curve: -1)
})


#pagebreak()

#finite.cetz.canvas({
  import finite.cetz.draw: set-style
  import finite.draw: state, transition

  set-style(transition: (curve: -1))

  state((0, 0), "q1")
  state((2.4, 0), "q2")

  transition("q1", "q2")
  transition("q2", "q1")
})
