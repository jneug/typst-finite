#import "@preview/diagraph-layout:0.0.1" as dia
#import "../../src/finite.typ"
#import "../../src/util.typ"

#set page(width: auto, height: auto, margin: 1cm)

#let aut = finite.create-automaton((
  q0: (q1: 1, q2: 0),
  q1: (q2: 1, q0: 0),
  q2: (q1: 0, q0: 1),
))

#finite.layout.diagraph(aut)

#dia.engine-list()

#for engine in dia.engine-list() {
  pagebreak()
  heading(level: 2)[Engine: #engine]
  finite.automaton(
    aut,
    layout: finite.layout.diagraph.with(engine: engine),
  )
}

#pagebreak()

#finite.automaton(
  (
    q0: (q1: "λ", q5: "λ"),
    q1: (q2: 0),
    q2: (q3: 0),
    q3: (q4: 0),
    q4: (q1: "λ", q5: "λ"),
    q5: (q6: "λ"),
    q6: (q7: "λ", q9: "λ", q13: "λ"),
    q7: (q8: "λ"),
    q8: (q17: "λ"),
    q9: (q10: 0),
    q10: (q11: 1),
    q11: (q12: 1),
    q12: (q17: "λ"),
    q13: (q14: 0),
    q14: (q15: 0),
    q15: (q16: 1),
    q16: (q17: "λ"),
    q17: (q18: "λ"),
    q18: (q19: "λ", q23: "λ"),
    q19: (q20: 1),
    q20: (q21: 1),
    q21: (q22: 1),
    q22: (q19: "λ", q23: "λ"),
    q23: none,
  ),
  layout: finite.layout.diagraph.with(engine: "neato", scale: 20),
  style: (
    transition: (
      curve: .4,
      label: (angle: 0deg),
    ),
    q6-q13: (curve: -.4),
    q13-q14: (curve: -.4),
    q14-q15: (curve: -.4),
    q15-q16: (curve: -.4),
    q16-q17: (curve: -.4),
  ),
)
