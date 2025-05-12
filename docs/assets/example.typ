#import "../../src/finite.typ": automaton

#set page(width: auto, height: auto, margin: 1cm, fill: none)

#let theme = (
  text: black,
  bg: white,
)
#if sys.inputs.at("theme", default: "light") == "dark" {
  theme.text = rgb("#d6d1cd")
  theme.bg = rgb("#343534")
}

#set text(theme.text) if theme == "dark"

#automaton(
  // @typstyle off
  (
    q0:       (q1: 0, q0: "0,1"),
    q1:       (q0: (0, 1), q2: "0"),
    q2:       none,
  ),
  initial: "q1",
  final: ("q0",),
  style: (
    transition: (stroke: theme.text),
    state: (fill: theme.bg, stroke: theme.text),
  ),
)
