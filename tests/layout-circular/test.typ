#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

#let aut = range(6).fold(
  (:),
  (d, i) => {
    d.insert("q" + str(i), (:))
    d
  },
)

#finite.automaton(
  aut,
  layout: finite.layout.circular.with(offset: 30deg),
  style: (
    state: (radius: .8),
    q1: (radius: 1),
    q4: (radius: .4),
  ),
)
