#import "../../src/util.typ": *


#let table = (
  a: (b: $epsilon$),
  b: (a: ($lambda + epsilon$, text(red, "fun"))),
  c: (a: (1, 2, 3), b: none, TRAP: (0,)),
  d: none,
)
#let expected-states = ("TRAP", "a", "b", "c", "d")
#let expected-inputs = ("0", "1", "2", "3", "fun", "ε", "λ + ε")
#let expected-labels = ("fun": text(red, "fun"), "ε": $epsilon$, "λ + ε": $lambda + epsilon$)


// ================================
// =           get-states         =
// ================================
//
#let states = get-states(table)
#assert.eq(states.sorted(), expected-states)


// ================================
// =       get-input-labels       =
// ================================

#let (inputs, input-labels) = get-inputs(table)

#assert.eq(inputs, expected-inputs)
#assert.eq(input-labels, expected-labels)


#let (inputs, input-labels) = get-inputs(
  table,
  input-labels: ("fun": "sad"),
)

#assert.eq(inputs, expected-inputs)
#assert.eq(input-labels, expected-labels + ("fun": "sad"))


#let (inputs, input-labels) = get-inputs(
  table,
  input-labels: i => raw(get.text(i)),
)

#assert.eq(inputs, expected-inputs)
#assert.eq(input-labels, inputs.map(i => (i, raw(get.text(i)))).to-dict())
