#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

#finite.cetz.canvas({
  import finite.draw: state, transition

  state((0, 0), "q0")
  state((4, 0), "q1")

  transition("q0", "q1")
  transition("q1", "q1")
})

#pagebreak()

#finite.cetz.canvas({
  import finite.draw: state, transition

  state((0, 0), "q0")
  state((4, 0), "q1")

  transition("q0", "q1", label: "x", curve: -1, stroke: .5pt + green)
  transition("q1", "q1", stroke: 2pt + red, mark: (end: "x"))
})

#pagebreak()

#finite.cetz.canvas({
  import finite.draw: state, transition

  state((0, 0), "q0")
  state((4, 2), "q1")

  transition("q0", "q1")
  transition("q1", "q1", anchor: right)
})

