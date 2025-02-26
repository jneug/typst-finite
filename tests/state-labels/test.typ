#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

#finite.automaton(
  (q0: (q1: 1), q1: (q0: 0)),
  style: (
    q0-q1: (label: (pos: 0.8)),
    q1-q0: (label: (pos: 0.2)),
  ),
)

#pagebreak()

#finite.automaton(
  (q0: (q1: 1), q1: (q0: 0)),
  style: (
    q0-q1: (label: (pos: 0.8)),
    transition: (label: (pos: 0.2)),
  ),
)
