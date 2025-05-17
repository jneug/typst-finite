#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 5mm)
#set text(font: "Liberation Sans")

#finite.automaton(
  (
    q0: (q1: none),
    q1: (q2: none),
    q2: (q3: none),
    q3: (q4: none),
    q4: (q5: none),
    q5: none,
  ),
  labels: range(6).fold(
    (:),
    (d, i) => {
      d.insert("q" + str(i), "FINITE".at(i))
      d
    },
  ),
  style: (
    state: (label: (size: 20pt)),
    transition: (curve: .8),
    q0: (initial: ""),
  ),
  layout: finite.layout.linear.with(spacing: .4),
)
