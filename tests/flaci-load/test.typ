#import "../../src/finite.typ": automaton, flaci

#set page(width: auto, height: auto, margin: 1cm)

#let automatons = (
  "DEA-1",
  "DEA-2",
  "DEA-3",
  "NEA-1",
  // "NKA-1",
)

#for file in automatons {
  page[
    #let aut = json(file + ".json")
    #flaci.automaton(aut, style: (q1: (fill: green)))
  ]
}

