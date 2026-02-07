#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

// === Test 1: Classic NFA "ends with 01" ===
// NFA: q0 loops on 0,1; q0->q1 on 0; q1->q2 on 1; q2 is final
#let nfa = (
  q0: (q0: (0, 1), q1: 0),
  q1: (q2: 1),
  q2: none,
)

#let dfa = finite.powerset(nfa)

// The result must be a DEA
#assert.eq(dfa.type, "DEA")
// Initial state is the powerset of {q0}
#assert.eq(dfa.initial, "{q0}")
// Final states are those containing q2
#assert.eq(dfa.final, ("{q0,q2}",))
// All expected states are present
#assert.eq(dfa.states.sorted(), ("{q0}", "{q0,q1}", "{q0,q2}").sorted())
// Inputs preserved
#assert.eq(dfa.inputs, ("0", "1"))

// Render the resulting DFA
#finite.transition-table(dfa)

#pagebreak()

#finite.automaton(
  dfa,
  layout: finite.layout.linear,
)

#pagebreak()

// === Test 2: NFA with overlapping transitions ===
#let nfa2 = (
  q0: (q1: "a", q2: "a"),
  q1: (q1: "b"),
  q2: (q2: "c"),
)

#let dfa2 = finite.powerset(nfa2, final: ("q1", "q2"))

#assert.eq(dfa2.type, "DEA")
#assert.eq(dfa2.initial, "{q0}")
// Both q1 and q2 are final, so {q1,q2} must be final
#assert(dfa2.final.contains("{q1,q2}"))

#finite.transition-table(dfa2)

#pagebreak()

#finite.automaton(
  dfa2,
  layout: finite.layout.linear,
)

#pagebreak()

// === Test 3: Custom state-format ===
#let dfa3 = finite.powerset(
  nfa,
  state-format: states => states.sorted().join(""),
)

#assert.eq(dfa3.initial, "q0")
#assert.eq(dfa3.states.sorted(), ("q0", "q0q1", "q0q2").sorted())

#finite.automaton(
  dfa3,
  layout: finite.layout.linear,
)
