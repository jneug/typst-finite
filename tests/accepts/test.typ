#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

#let aut = finite.create-automaton((
  q0: (q1: "a"),
  q1: (q1: ("a", "b"), q2: "c"),
  q2: (q0: "b"),
))

#finite.automaton(aut)

#finite.accepts(aut, "abc")

#pagebreak()

#finite.accepts(
  aut,
  "abbaac",
  format: (spec, states) => {
    let style = (:)
    for i in range(states.len() - 1) {
      let key = str(states.at(i).first()) + "-" + str(states.at(i + 1).first())
      style.insert(key, (stroke: red))
      style.insert(states.at(i).first(), (stroke: red))
      style.insert(states.at(i + 1).first(), (stroke: red))
    }
    finite.automaton(spec, style: style)
  },
)

#pagebreak()

#let aut = finite.create-automaton((
  q0: (q1: "la"),
  q1: (q1: ("la", "le"), q2: "lu"),
  q2: (q0: "lu"),
))

#finite.automaton(aut)

#finite.accepts(aut, "lalelu")

#finite.accepts(aut, "lalalulu")

#pagebreak()

#let aut = finite.create-automaton((
  q0: (q1: "la"),
  q1: (q1: (1, "x"), q2: "foo"),
  q2: (q0: 0),
))

#finite.automaton(aut)

#finite.accepts(aut, "la1xfoo")

#pagebreak()

#let aut = finite.create-automaton(
  (
    q0: (q1: "a"),
    q1: (q1: ("a", "b"), q2: "c"),
    q2: (q0: "b"),
  ),
  labels: (
    q0: [START],
    q2: [END],
  ),
  input-labels: (
    a: $alpha$,
    b: $beta$,
    c: $gamma$,
  ),
)

#finite.automaton(aut)
#finite.accepts(aut, "abc")
