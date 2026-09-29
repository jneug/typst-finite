#import "../../src/finite.typ": transition-table

#set page(width: auto, height: auto, margin: 1cm)

#transition-table(
  (
    q0: (q1: 0, q0: "e"),
    q1: none
  ),
  labels: (
    q0: [A],
    q1: [B]),
  input-labels: (
    e: $epsilon$
  )
)