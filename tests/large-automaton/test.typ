/// [skip]

#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

#let spacing = 2
#let splay = 5
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
  layout: (
    q0: (0.6, 0),
    q1: (spacing, 0),
    q2: (2 * spacing, 0),
    q3: (3 * spacing, 0),
    q4: (4 * spacing, 0),
    q5: (5 * spacing, 0),
    q6: (5 * spacing, -splay),
    q7: (3 * spacing, spacing - splay),
    q8: (2 * spacing, spacing - splay),
    q9: (4 * spacing, -splay),
    q10: (3 * spacing, -splay),
    q11: (2 * spacing, -splay),
    q12: (2 * spacing, -splay),
    q13: (4 * spacing, -spacing - splay),
    q14: (3 * spacing, -spacing - splay),
    q15: (2 * spacing, -spacing - splay),
    q16: (1 * spacing, -spacing - splay),
    q17: (0, -splay),
    q18: (0, -2 * splay),
    q19: (spacing, -2 * splay),
    q20: (2 * spacing, -2 * splay),
    q21: (3 * spacing, -2 * splay),
    q22: (4 * spacing, -2 * splay),
    q23: (5 * spacing, -2 * splay),
  ),
  style: (
    transition: (
      curve: 0,
      label: (angle: 0deg),
    ),
    q0-q5: (curve: 1.5),
    q4-q1: (curve: 1.5),
    q18-q23: (curve: 1.5),
    q22-q19: (curve: 1.5),
  ),
)
