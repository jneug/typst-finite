#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

#let aut = (
  q0: (q1: "a"),
  q1: (q1: ("a", "b"), q2: ("c", "b")),
  q2: (q0: "b", q2: "c"),
)
#finite.transition-table(aut)

#pagebreak()

#finite.transition-table(
  aut,
  format: (c, r, v) => if c == 0 and r == 0 [
    $delta$
  ] else if c == 0 [
    #strong(v)
  ] else {
    raw(str(v))
  },
)

#pagebreak()

#finite.transition-table(
  aut,
  fill: (c, r) => (orange, yellow).at(calc.rem(c + r, 2)),
  format: (c, r, v) => text((yellow, orange).at(calc.rem(c + r, 2)), weight: "bold", v),
)
