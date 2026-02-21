#import "@preview/diagraph-layout:0.0.1" as dia
#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

#let aut = finite.create-automaton((
  q0: (q1: 1, q2: 0),
  q1: (q2: 1, q0: 0),
  q2: (q1: 0, q0: 1),
))

#finite.layout.diagraph-layout(aut)


#for engine in dia.engine-list() {
  pagebreak()
  heading(level: 2)[Engine: #engine]
  finite.automaton(
    aut,
    layout: finite.layout.diagraph-layout.with(engine: engine, scale: 10),
  )
}
