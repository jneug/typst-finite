#import "./cmd.typ"
#import "./util.typ": get, to-spec, vec-to-align, align-to-vec

#let load(data) = {
  assert(data.at("type", default: "ERROR") in ("DEA", "NEA"))
  let automaton = data.at("automaton", default: (:))

  // Scaling factor for FLACI coordinates to CeTZ conversion
  let scaling = .02

  // Some FLACI default styles
  let style = (
    transition: (
      curve: 0,
      label: (angle: 0deg),
    ),
  )

  // Variable declarations
  let transitions = (:)
  let states = ()
  let final = ()
  let initial = none
  let inputs = automaton.at("Alphabet", default: ())
  let id-map = (:)
  let layout = (:)

  // Parse states
  for state in automaton.at("States", default: ()) {
    let name = state.Name

    // Prepare state
    states.push(name)
    transitions.insert(name, (:))
    id-map.insert(str(state.ID), name)

    // Final and initial states
    if state.Final {
      final.push(name)
    }
    if state.Start {
      initial = name
    }

    // Layout
    layout.insert(
      name,
      (state.x * scaling, state.y * -scaling),
    )

    // Style
    style.insert(
      name,
      (
        radius: state.Radius * scaling,
      ),
    )
  }

  // Second pass to parse transitions
  for state in automaton.at("States", default: ()) {
    let name = state.Name
    let id = state.ID

    let state-transitions = (:)
    for transition in state.Transitions {
      if transition.Source == id {
        state-transitions.insert(id-map.at(str(transition.Target)), transition.Labels)
      } else {
        state-transitions.insert(id-map.at(str(transition.Source)), transition.Labels)
      }

      if transition.Source == transition.Target {
        let vec = (transition.x, -transition.y)
        let align = vec-to-align(vec)
        style.insert(name + "-" + name, (anchor: align))
      }
    }
    transitions.insert(state.Name, state-transitions)
  }

  // Do some cleanup of style (eg curve for double transitions)
  for (state, state-transitions) in transitions {
    for target-state in state-transitions.keys() {
      if state in transitions.at(target-state) {
        let name = state + "-" + target-state
        let sty = style.at(name, default: (:))
        style.insert(name, get.dict-merge((curve: .6), sty))
      }
    }
  }


  return (to-spec(transitions, states: states, inputs: inputs, initial: initial, final: final), layout, style)
}


/// Show a FLACI file as an @cmd:automaton.
/// @property(see: (<cmd:util:to-spec>))
/// -> content
#let automaton(
  data,
  layout: auto,
  merge-layout: true,
  style: auto,
  merge-style: true,
  ..args,
) = {
  let (spec, lay, sty) = load(data)

  if layout == auto {
    layout = lay
  } else if merge-layout and type(layout) == dictionary {
    layout = get.dict-merge(lay, layout)
  }
  if style == auto {
    style = sty
  } else if merge-style and type(style) == dictionary {
    style = get.dict-merge(sty, style)
  }

  cmd.automaton(spec, layout: layout, style: style, ..args)
}
