#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)


#finite.automaton(
  (q0: (q1: ("a", "b")), q1: (q0: $epsilon$)),
  style: (
    q0-q1: (label: (pos: 0.8)),
    q1-q0: (label: (pos: 0.2)),
  ),
)

#pagebreak()

#finite.automaton(
  (q0: (q1: "a,b"), q1: (q0: "e")),
  input-labels: (
    e: $epsilon$,
  ),
  style: (
    q0-q1: (label: (pos: 0.8)),
    q1-q0: (label: (pos: 0.2)),
  ),
)

#pagebreak()

#finite.automaton(
  (q0: (q1: "a,b"), q1: (q0: "e")),
  input-labels: i => if i == "e" { $epsilon$ } else { i },
  style: (
    q0-q1: (label: (pos: 0.8)),
    q1-q0: (label: (pos: 0.2)),
  ),
)
