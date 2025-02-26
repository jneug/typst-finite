#import "./draw.typ"

#import "./layout.typ" as _layout
#import "./util.typ" as util: to-spec, cetz


/// Creates a full @type:automaton specification for a finite automaton.
/// The function accepts either a partial specification and
/// adds the missing keys by parsing the available information
/// or takes a @type:transition-table and parses it into a full specification.
///
/// ```example
/// #finite.create-automaton((
///   q0: (q1: 0, q0: (0,1)),
///   q1: (q0: (0,1), q2: "0"),
///   q2: none,
/// ))
/// ```
///
/// If any of the keyword arguments are set, they will
/// overwrite the information in #arg[spec].
///
/// -> automaton
#let create-automaton(
  spec,
  states: auto,
  initial: auto,
  final: auto,
  inputs: auto,
) = {
  // TODO: (jneug) add asserts to react to malicious specs
  util.assert.any-type(dictionary, spec)

  // TODO: (jneug) check for duplicate names
  if "transitions" not in spec {
    spec = (transitions: spec)
  }

  // Make sure transition inputs are string arrays
  for (state, trans) in spec.transitions {
    if util.is-none(trans) {
      trans = (:)
    }
    for (s, inputs) in trans {
      if type(inputs) != array {
        trans.at(s) = (str(inputs),)
      } else {
        trans.at(s) = inputs.map(str)
      }
    }
    spec.transitions.at(state) = trans
  }

  // TODO (jneug) validate given states with transitions
  if "states" not in spec {
    spec.insert(
      "states",
      util.def.if-auto(
        states,
        def: spec
          .transitions
          .pairs()
          .fold(
            (),
            (
              a,
              (s, t),
            ) => {
              a.push(s)
              return a + t.keys()
            },
          )
          .dedup(),
      ),
    )
  }


  if "initial" not in spec {
    spec.insert(
      "initial",
      util.def.if-auto(
        initial,
        def: spec.states.first(),
      ),
    )
  }

  // Insert final state
  if "final" not in spec {
    if util.is-auto(final) {
      final = (spec.states.last(),)
    } else if is-none(final) {
      final = ()
    }
    spec.insert("final", final)
  }

  if "inputs" not in spec {
    if util.is-auto(inputs) {
      inputs = util.get-inputs(spec.transitions)
    }
    spec.insert("inputs", inputs)
  } else {
    spec.inputs = spec.inputs.map(str).sorted()
  }

  if util.is-dea(spec.transitions) {
    spec.insert("type", "DEA")
  } else {
    spec.insert("type", "NEA")
  }

  return spec + (finite-spec: true)
}


/// Draw an automaton from a specification.
///
/// #arg[spec] is a dictionary with a specification for a
/// finite automaton. See above for a description of the
/// specification dictionaries.
///
/// The following example defines three states `q0`, `q1` and `q2`.
/// For the input `0`, `q0` transitions to `q1` and for the inputs `0` and `1` to `q2`.
/// `q1` transitions to `q0` for `0` and `1` and to `q2` for `0`. `q2` has no transitions.
/// #codesnippet[```typ
/// #automaton((
///   q0: (q1:0, q0:(0, 1)),
///   q1: (q0:(0, 1), q2:0),
///   q2: none
/// ))
/// ```]
///
/// #arg[inital] and #arg[final] can be used to customize the initial and final states.
/// #info-alert[The #arg[inital] and #arg[final] will be removed in future
///   versions in favor of automaton specs.
/// ]
///
/// - spec (spec): Automaton specification.
/// - initial (string, auto, none): The name of the initial state. For #value(auto), the first state in #arg[spec] is used.
/// - final (array, auto, none): A list of final state names. For #value(auto), the last state in #arg[spec] is used.
/// - labels (dictionary): A dictionary with labels for states and transitions.
///   #example[```
///   #finite.automaton(
///     (q0: (q1:none), q1: none),
///     labels: (q0: [START], q1: [END])
///   )
///   ```]
/// - style (dictionary): A dictionary with styles for states and transitions.
/// - state-format (function): A function #lambda("string", ret:"content") to format state labels.
///    The function will get the states name as a string and should return the final label as #dtype("content").
///   #example[```
///   #finite.automaton(
///     (q0: (q1:none), q1: none),
///     state-format: (label) => upper(label)
///   )
///   ```]
/// - input-format (function): A function #lambda("array", ret:"content")
///   to generate transition labels from input values. The functions will be
///   called with the array of inputs and should return the final label for
///   the transition. This is only necessary, if no label is specified.
///   #example[```
///   #finite.automaton(
///     (q0: (q1:(3,0,2,1,5)), q1: none),
///     input-format: (inputs) => inputs.sorted().rev().map(str).join("|")
///   )
///   ```]
/// - layout (dictionary,function): Either a dictionary with (`state`: `coordinate`)
///   pairs, or a layout function. See below for more information on layouts.
///   #example[```
///   #finite.automaton(
///     (q0: (q1:none), q1: none),
///     layout: (q0: (0,0), q1: (rel:(-2,1)))
///   )
///   ```]
/// - ..canvas-styles (any): Arguments for #cmd-(module:"cetz")[canvas]
/// -> content
#let automaton(
  spec,
  initial: auto,
  final: auto,
  labels: (:),
  style: (:),
  state-format: label => {
    let m = label.match(regex(`^(\D+)(\d+)$`.text))
    if m != none {
      [#m.captures.at(0)#sub(m.captures.at(1))]
    } else {
      label
    }
  },
  input-format: inputs => inputs.map(str).join(","),
  layout: _layout.linear,
  ..canvas-styles,
) = {
  spec = to-spec(spec, initial: initial, final: final)

  // use a dict with coordinates as custom layout
  if util.is-dict(layout) {
    layout = _layout.custom.with(positions: layout)
  }

  let (coordinates, anchors) = layout(spec, style: style)

  cetz.canvas(
    ..canvas-styles,
    {
      import cetz.draw: set-style
      import draw: state, transition

      set-style(..style)

      // Create states
      for name in spec.states {
        state(
          coordinates.at(name, default: ()),
          name,
          label: labels.at(name, default: state-format(name)),
          initial: (name == spec.initial),
          final: (name in spec.final),
          anchor: anchors.at(name, default: none),
          ..style.at(name, default: (:)),
        )
      }

      // Create transitions
      for (from, transitions) in spec.transitions {
        if util.is-dict(transitions) {
          for (to, inputs) in transitions {
            let name = from + "-" + to

            // prepare inputs (may be a string or int)
            if inputs == none {
              inputs = ()
            } else if not util.is-arr(inputs) {
              inputs = str(inputs).split(",")
            }

            // prepare label
            let label = labels.at(
              name,
              default: input-format(inputs),
            )
            if util.is-dict(label) and "text" not in label {
              label.text = input-format(inputs)
            }

            // create transition
            transition(
              from,
              to,
              inputs: inputs,
              label: label,
              ..style.at(name, default: (:)),
            )
          }
        }
      }
    },
  )
}

/// Displays a transition table for an automaton.
///
/// #arg[spec] is a dictionary with a specification for a
/// finite automaton. See above for a description of the
/// specification dictionaries.
///
/// The table will show states in rows and inputs in columns:
/// #example(```
/// #finite.transition-table((
///   q0: (q1: 0, q0: (1,0)),
///   q1: (q0: 1, q2: (1,0)),
///   q2: (q0: 1, q2: 0),
/// ))
/// ```)
///
/// #info-alert[The #arg[inital] and #arg[final] will be removed in future
///   versions in favor of automaton specs.
/// ]
///
/// - spec (spec): Automaton specification.
/// - initial (string, auto, none): The name of the initial state. For #value(auto), the first state in #arg[states] is used.
/// - final (array, auto, none): A list of final state names. For #value(auto), the last state in #arg[states] is used.
/// - format (function): A function to format the value in a table column. The function takes a column index and
///   a string and generates content: #lambda("integer", "string", ret:"content").
///   #example[```
///   #finite.transition-table((
///     q0: (q1: 0, q0: (1,0)),
///     q1: (q0: 1, q2: (1,0)),
///     q2: (q0: 1, q2: 0),
///   ), format: (col, value) => if col == 1 { strong(value) } else [#value])
///   ```]
/// - format-list (function): Formats a list of states for display in a table cell. The function takes an array of state names and generates a string to be passed to #arg[format]:
/// #lambda("array", ret:"string")
///   #example[```
///   #finite.transition-table((
///     q0: (q1: 0, q0: (1,0)),
///     q1: (q0: 1, q2: (1,0)),
///     q2: (q0: 1, q2: 0),
///   ), format-list: (states) => "[" + states.join(" | ") + "]")
///   ```]
/// - ..table-style (any): Arguments for #builtin("table").
/// -> content
#let transition-table(
  spec,
  initial: auto,
  final: auto,
  format: (col, row, v) => raw(str(v)),
  format-list: states => states.join(", "),
  ..table-style,
) = {
  spec = to-spec(spec, initial: initial, final: final)

  let table-cnt = (
    format(0, 0, ""),
  )
  for (col, input) in spec.inputs.enumerate() {
    table-cnt.push(format(col + 1, 0, input))
  }

  for (row, (state, transitions)) in spec.transitions.pairs().enumerate() {
    table-cnt.push(format(0, row + 1, state))
    if util.is-dict(transitions) {
      for (i, char) in spec.inputs.enumerate() {
        let to = ()
        for (name, label) in transitions {
          if util.is-str(label) {
            label = label.split(",")
          }
          label = util.def.as-arr(label).map(str)

          if char in label {
            to.push(name)
          }
        }
        table-cnt.push(if to == () { "" } else { format(i + 1, row + 1, format-list(to)) })
      }
    }
  }

  table(
    columns: 1 + spec.inputs.len(),
    fill: (c, r) => if r == 0 or c == 0 {
      luma(240)
    },
    align: center + horizon,
    ..table-style,
    ..table-cnt
  )
}


/// Creates a deterministic finite automaton from a nondeterministic one by using powerset construction.
///
/// See #link("https://en.wikipedia.org/wiki/Powerset_construction")[the Wikipedia article on powerset construction] for further
/// details on the algorithm.
///
/// #arg[spec] is a dictionary with a specification for a
/// finite automaton. See above for a description of the
/// specification dictionaries.
///
/// - spec (spec): Automaton specification.
/// - initial (string, auto, none): The name of the initial state. For #value(auto), the first state in #arg[states] is used.
/// - final (array, auto, none): A list of final state names. For #value(auto), the last state in #arg[states] is used.
/// - state-format (function): A function to generate the new state names from a list of states.
///   The function takes an array of strings and returns a string: #lambda("array", ret:"string").
#let powerset(
  spec,
  initial: auto,
  final: auto,
  state-format: states => "{" + states.sorted().join(",") + "}",
) = {
  spec = to-spec(spec, initial: initial, final: final)

  let table = util.transpose-table(spec.transitions)

  let (new-initial, new-final) = (
    state-format((spec.initial,)),
    (),
  )

  let powerset = (:)
  let queue = ((spec.initial,),)
  while queue.len() > 0 {
    let cur = queue.remove(0)
    let key = state-format(cur)

    if key not in powerset {
      powerset.insert(key, (:))

      if cur.any(s => s in spec.final) {
        new-final.push(key)
      }

      for inp in spec.inputs {
        let trans = ()
        for s in cur {
          let s-trans = table.at(s)
          if inp in s-trans {
            trans += s-trans.at(inp)
          }
        }
        trans = trans.dedup().sorted()
        powerset.at(key).insert(inp, trans)
        queue.push(trans)
      }
    }
  }

  for (s, t) in powerset {
    for (i, states) in t {
      powerset.at(s).at(i) = state-format(states)
    }
  }

  return to-spec(
    util.transpose-table(powerset),
    initial: new-initial,
    final: new-final,
    inputs: spec.inputs,
  )
}

/// Adds a trap state to a partial DFA and completes it.
///
/// Deterministic automata need to specify a transition for every
/// possible input. If those inputs don't transition to another
/// state, a trap-state is introduced, that is not final
/// and can't be left by any input. To simplify
/// transition diagrams, these trap-states are oftentimes
/// not drawn. This function adds a trap-state to such a
/// partial automaton and thus completes it.
///
/// #example[```
/// #finite.transition-table(finite.add-trap((
///   q0: (q1: 0),
///   q1: (q0: 1)
/// )))
/// ```]
///
/// // >>> finite.add-trap((transitions: (q0: (q1: ())), inputs: (0,1))) == finite.to-spec((transitions: (q0: (TRAP:("0","1")), TRAP: (TRAP: ("0","1"))), inputs: ("0","1")))
///
/// - spec (spec): Automaton specification.
/// - trap-name (string): Name for the new trap-state.
#let add-trap(spec, trap-name: "TRAP") = {
  spec = to-spec(spec)

  let table = util.transpose-table(spec.transitions)

  let trap-added = false
  for (s, values) in table {
    for inp in spec.inputs {
      if inp not in values {
        values.insert(inp, (trap-name,))
        trap-added = true
      }
    }
    table.at(s) = values
  }

  if trap-added {
    table.insert(
      trap-name,
      spec.inputs.fold(
        (:),
        (d, i) => {
          d.insert(i, (trap-name,))
          return d
        },
      ),
    )
    spec.states.push(trap-name)
  }

  spec.at("transitions") = util.transpose-table(table)
  return spec
}


/// Tests if a #arg[word] is accepted by a given automaton.
///
/// The result if either #value(false) or an array of tuples
/// with a state name and the input used to transition to the
/// next state. The array is a possible path to an accepting
/// final state. The last tuple always has #value(none) as
/// an input.
/// #example[```
/// #let aut = (
///   q0: (q1: 0),
///   q1: (q0: 1)
/// )
/// #finite.accepts(aut, "01010")
///
/// #finite.accepts(aut, "0101")
/// ```]
///
/// - spec (spec): Automaton specification.
/// - word (string): A word to test.
/// - format (function): A function to format the result.
#let accepts(
  spec,
  word,
  format: (spec, states) => states
    .map(((s, i)) => if i != none [
      #s #box[#sym.arrow.r#place(top + center, dy: -88%)[#text(.88em, raw(i))]]
    ] else [#s])
    .join(),
) = {
  spec = to-spec(spec)

  let (transitions, initial, final) = (
    spec.at("transitions", default: (:)),
    spec.at("initial", default: none),
    spec.at("final", default: ()),
  )
  transitions = util.transpose-table(transitions)

  util.assert.that(transitions != (:))
  util.assert.that(initial != none)
  util.assert.that(final != ())

  let next-symbol(word, inputs) = {
    for sym in inputs {
      if word.starts-with(sym) {
        return (word.slice(sym.len()), sym)
      }
    }
    return (word, none)
  }
  let traverse(word, state) = {
    if word.len() > 0 {
      let (word, symbol) = next-symbol(word, spec.inputs)
      if state in transitions {
        if symbol != none and symbol in transitions.at(state) {
          for next-state in transitions.at(state).at(symbol) {
            let states = traverse(word, next-state)
            if states != false {
              return ((state, symbol),) + states
            }
          }
        }
      }
      return false
    }
    // Word accepted?
    if state in final {
      return ((state, none),)
    } else {
      return false
    }
  }

  let result = traverse(word, initial)
  if result == false {
    return false
  } else {
    return format(spec, result)
  }
}
