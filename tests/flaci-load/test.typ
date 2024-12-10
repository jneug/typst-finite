#import "../../src/finite.typ": automaton, flaci

#set page(width: auto, height: auto, margin: 1cm)

#for i in range(4) {
  page[
    #let aut = json("automaton" + str(i + 1) + ".json")
    #flaci.automaton(aut, style: (q1: (fill: green)))
  ]
}

