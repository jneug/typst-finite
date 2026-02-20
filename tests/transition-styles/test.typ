#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

#finite.cetz.canvas({
  import finite.cetz.draw: set-style
  import finite.draw: state, transition

  set-style(loop: (stroke: 1pt + blue))
  set-style(transition: (stroke: 1pt + green))

  state((0, 0), "q0")
  state((4, 0), "q1")

  transition("q0", "q1", inputs: (1, 2, 3, 4))
  transition("q1", "q0", inputs: (1, 2, 3, 4), label: "A")
  transition("q1", "q1", label: "1,2,3", stroke: 2pt + red)
})
