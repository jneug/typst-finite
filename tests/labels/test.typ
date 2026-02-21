#import "../../src/finite.typ"
#import "../../src/util.typ"

#set page(width: auto, height: auto, margin: 1cm)

#finite.automaton(
  (q0: (q1: ("a", "b")), q1: (q0: ("a", "b"))),
  labels: (
    q0: "[START]",
    q1: $delta$,
    "q0-q1": "a and b",
  ),
  style: (q0: (radius: 1)),
)
