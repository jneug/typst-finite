#import "../../src/finite.typ"

#let aut = (
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
)

#let spec = finite.create-automaton(aut)

#assert.eq(spec.type, "NEA")
#assert.eq(spec.initial, "q0")
#assert.eq(spec.final, ("q23",))
#assert.eq(spec.states.sorted(), aut.keys().sorted())
#assert.eq(spec.inputs.sorted(), ("0", "1", "λ"))
