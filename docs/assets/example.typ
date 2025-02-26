#import "../../src/finite.typ": automaton

#set page(width: auto, height: auto, margin: 1cm)

#automaton((
  q0: (q1: 0, q0: "0,1"),
  q1: (q0: (0, 1), q2: "0"),
  q2: none,
))
