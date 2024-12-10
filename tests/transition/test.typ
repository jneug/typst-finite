#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

#finite.cetz.canvas({
  import finite.draw: state, transition

  state((0, 0), "q0")
  state((4, 0), "q1")

  transition("q0", "q1", inputs: (1, 2, 3, 4))
  transition("q1", "q0", inputs: (1, 2, 3, 4), label: "A")
  transition("q1", "q1", label: "1,2,3")
})

#pagebreak()

#finite.cetz.canvas({
  import finite.draw: state, transition

  state((0, 0), "q0")
  state((4, 0), "q1")
  state((4, -4), "q2")
  state((0, -4), "q3")

  transition("q0", "q1", label: "A")
  transition("q1", "q2", label: "A", stroke: blue)
  transition("q2", "q3", label: (text: "A"))
  transition("q3", "q0", label: (text: "A", size: 2em))
  transition("q2", "q1", label: (text: "A", color: green, pos: .8), stroke: blue)
  transition("q0", "q3", label: (text: "A", size: 2em, pos: 0.2, dist: -.33, angle: 0deg), stroke: blue)
})
