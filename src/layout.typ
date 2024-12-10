#import "util.typ"
#import util: default-style, cetz, test, assert-dict, assert-spec


#let create-layout(positions: (:), anchors: (:)) = {
  (positions, anchors)
}


/// Create a custom layout from a positioning function.
///
/// See "Creating custom layouts" for more information.
///
/// #example(breakable:true)[```
/// #let aut = range(6).fold((:), (d, s) => {d.insert("q"+str(s), none); d})
/// #finite.automaton(
///   aut,
///   initial: none, final: none,
///   layout:finite.layout.custom.with(positions:(..) => (
///     q0: (0,0), q1: (0,5), rest:(rel: (2,-1))
///   ))
/// )
/// ```]
///
/// - position (coordinate): Position of the anchor point.
/// - positions (function): A function #lambda("dictionary","dictionary","array",ret:"dictionary") to compute coordinates for each state.\
///    The function gets the current CETZ context, a dictionary of computed radii for each
///    state and a list with all state elements to position. The returned dictionary
///    contains each states name as a key and the new coordinate as a value.
///
///    The result may specify a `rest` key that is used as a default coordinate. This makes
///    sense in combination with a relative coordinate like `(rel:(2,0))`.
/// - name (string): Name for the element to access later.
/// - anchor (string): Name of the anchor to use for the layout.
/// - body (array): Array of CETZ elements to cetz.draw.
#let custom(
  spec,
  positions: (:),
  position: (0, 0),
  style: (:),
) = {
  assert-spec(spec)
  assert-dict(positions)

  let rest = positions.at("rest", default: (rel: (4, 0)))

  for state in spec.states {
    positions.insert(
      state,
      (
        rel: position,
        to: positions.at(state, default: util.call-or-get(rest, state)),
      ),
    )
  }

  // return coordinates
  return create-layout(positions: positions)
}


/// Arrange states in a line.
///
/// The direction of the line can be set via #arg[dir] either to an #dtype("alignment")
/// or a `vector` with a x and y shift.
///
/// #example(breakable:true)[```
/// #let aut = range(6).fold((:), (d, s) => {d.insert("q"+str(s), none); d})
/// #finite.automaton(
///   aut,
///   initial: none, final: none,
///   layout:finite.layout.linear.with(dir: right)
/// )
/// #finite.automaton(
///   aut,
///   initial: none, final: none,
///   layout:finite.layout.linear.with(dir:(.5, -.2))
/// )
/// ```]
///
/// - position (coordinate): Position of the anchor point.
/// - dir (vector,alignment,2d alignment): Direction of the line.
/// - spacing (float): Spacing between states on the line.
/// - name (string): Name for the element to access later.
/// - anchor (string): Name of the anchor to use for the layout.
/// - body (array): Array of CETZ elements to cetz.draw.
#let linear(
  spec,
  dir: right,
  spacing: .6,
  position: (0, 0),
  style: (:),
) = {
  assert-spec(spec)

  let dir = dir
  if test.any-type("alignment", "2d alignment", dir) {
    dir = util.align-to-vec(dir)
  }
  dir = cetz.vector.norm(dir)
  let dir-angle = cetz.vector.angle2((0, 0), dir)
  let spacing-vec = cetz.vector.scale(dir, spacing)

  let positions = (:)
  let anchors = (:)

  let prev-name = none
  for name in spec.states {
    positions.insert(
      name,
      if prev-name == none {
        position
      } else {
        (
          rel: spacing-vec,
          to: prev-name + ".state." + repr(dir-angle),
        )
      },
    )
    anchors.insert(
      name,
      if prev-name == none {
        "center"
      } else {
        repr(dir-angle + 180deg)
      },
    )
    prev-name = name
  }

  // return coordinates
  return create-layout(positions: positions, anchors: anchors)
}


/// Arrange states in a circle.
///
/// #example(breakable:true)[```
/// #let aut = range(6).fold((:), (d, s) => {d.insert("q"+str(s), none); d})
/// #grid(columns: 2, gutter: 2em,
///   finite.automaton(
///     aut,
///     initial: none, final: none,
///     layout:finite.layout.circular,
///     style: (q0: (fill: yellow.lighten(60%)))
///   ),
///   finite.automaton(
///     aut,
///     initial: none, final: none,
///     layout:finite.layout.circular.with(offset:45deg),
///     style: (q0: (fill: yellow.lighten(60%)))
///   ),
///   finite.automaton(
///     aut,
///     initial: none, final: none,
///     layout:finite.layout.circular.with(dir:left),
///     style: (q0: (fill: yellow.lighten(60%)))
///   ),
///   finite.automaton(
///     aut,
///     initial: none, final: none,
///     layout:finite.layout.circular.with(dir:left, offset:45deg),
///     style: (q0: (fill: yellow.lighten(60%)))
///   )
/// )
/// ```]
///
/// - position (coordinate): Position of the anchor point.
/// - dir (alignment): Direction of the circle. Either #value(left) or #value(right).
/// - spacing (float): Spacing between states on the line.
/// - radius (float,auto): Either a fixed radius or #value(auto) to calculate a suitable the radius.
/// - offset (angle): An offset angle to place the first state at.
/// - name (string): Name for the element to access later.
/// - anchor (string): Name of the anchor to use for the layout.
/// - body (array): Array of CETZ elements to cetz.draw.
#let circular(
  spec,
  position: (0, 0),
  dir: right,
  spacing: .6,
  radius: auto,
  offset: 0deg,
  style: (:),
) = {
  // TODO: (ngb) fix positioning
  let radii = util.get-radii(spec, style: style)
  let len = radii.values().fold(0, (s, r) => s + 2 * r + spacing)

  let radius = radius
  if util.is-auto(radius) {
    radius = len / (2 * calc.pi)
  } else {
    len = 2 * radius * calc.pi
  }

  let positions = (:)
  let anchors = (:)
  let at = none
  for name in spec.states {
    let radius = radii.at(name)
    let ang = 0deg
    let ang = offset + util.math.map(
      0.0,
      len,
      0deg,
      360deg,
      at + radius,
    )

    let pos = (
      rel: (
        -radius * calc.cos(ang),
        if dir == right {
          radius
        } else {
          -radius
        } * calc.sin(ang),
      ),
      to: position,
    )

    positions.insert(name, pos)

    // anchors.insert(name, "state." + repr(-ang))

    at += 2 * radius + spacing
  }
  return create-layout(positions: positions, anchors: anchors)
}


/// Arrange states in rows and columns.
///
/// #example[```
/// #let aut = range(6).fold((:), (d, s) => {d.insert("q"+str(s), none); d})
/// #finite.automaton(
///   aut,
///   initial: none, final: none,
///   layout:finite.layout.grid.with(columns:3)
/// )
/// ```]
///
/// - position (coordinate): Position of the anchor point.
/// - columns (integer): Number of columns per row.
/// - spacing (float): Spacing between states on the grid.
/// - name (string): Name for the element to access later.
/// - anchor (string): Name of the anchor to use for the layout.
/// - body (array): Array of CETZ elements to cetz.draw.
#let grid(
  spec,
  columns: 4,
  spacing: .6,
  position: (0, 0),
  style: (:),
) = {
  let spacing = if not util.is-arr(spacing) {
    (x: spacing, y: spacing)
  } else {
    (x: spacing.first(), y: spacing.last())
  }

  let radii = util.get-radii(spec, style: style)
  let max-radius = calc.max(..radii.values())

  let positions = (:)
  for (i, name) in spec.states.enumerate() {
    let (row, col) = (
      calc.quo(i, columns),
      calc.rem(i, columns),
    )
    positions.insert(
      name,
      (
        rel: (
          col * (2 * max-radius + spacing.x),
          row * (2 * max-radius + spacing.y),
        ),
        to: position,
      ),
    )
  }
  return create-layout(positions: positions)
}


/// Arrange states in a grid, but alternate the direction in every even and odd row.
///
/// #example(breakable:true)[```
/// #let aut = range(6).fold((:), (d, s) => {d.insert("q"+str(s), none); d})
/// #finite.automaton(
///   aut,
///   initial: none, final: none,
///   layout:finite.layout.snake.with(columns:3)
/// )
/// ```]
///
/// - position (coordinate): Position of the anchor point.
/// - columns (integer): Number of columns per row.
/// - spacing (float): Spacing between states on the line.
/// - name (string): Name for the element to access later.
/// - anchor (string): Name of the anchor to use for the layout.
/// - body (array): Array of CETZ elements to cetz.draw.
#let snake(
  spec,
  columns: 4,
  spacing: .6,
  position: (0, 0),
  style: (:),
) = {
  let spacing = if not util.is-arr(spacing) {
    (x: spacing, y: spacing)
  } else {
    (x: spacing.first(), y: spacing.last())
  }

  let radii = util.get-radii(spec, style: style)
  let max-radius = calc.max(..radii.values())

  let positions = (:)
  for (i, name) in spec.states.enumerate() {
    let (row, col) = (
      calc.quo(i, columns),
      calc.rem(i, columns),
    )
    positions.insert(
      name,
      if calc.odd(row) {
        (
          rel: (
            (columns - col - 1) * (2 * max-radius + spacing.x),
            row * (2 * max-radius + spacing.y),
          ),
          to: position,
        )
      } else {
        (
          rel: (
            col * (2 * max-radius + spacing.x),
            row * (2 * max-radius + spacing.y),
          ),
          to: position,
        )
      },
    )
  }
  return create-layout(positions: positions)
}


/// Creates a group layout that collects states into groups that are
/// positioned by specific sub-layouts.
///
/// See @sec:showcase for an example.
///
/// - position (coordinate): Position of the anchor point.
/// - name (string): Name for the element to access later.
/// - anchor (string): Name of the anchor to use for the layout.
/// - grouping (int, array): Either an integer to collect states into
///     roughly equal sized groups or an array of arrays that specify which states
///     (by name) are in what group.
/// - spacing (float): A spacing between sub-group layouts.
/// - layout (array): An array of layouts to use for each group. The first group of
///     states will be passed to the first layout and so on.
/// - body (array): Array of CETZ elements to cetz.draw.
#let group(
  spec,
  grouping: auto,
  spacing: .8,
  layout: linear.with(dir: bottom),
  position: (0, 0),
  style: (:),
) = {
  assert-spec(spec)

  let groups = ()
  let rest = ()

  let grouping = util.def.if-auto(grouping, def: spec.states.len())

  // collect state groups
  if util.is-int(grouping) {
    // by equal size
    groups = spec.states.chunks(grouping)
  } else if util.is-arr(grouping) {
    groups = grouping
    // collect remaining states into "rest" group
    rest = spec.states.filter(s => not groups.any(g => s in g))
  }

  let positions = (:)
  let anchors = (:)
  let last-name = none
  for (i, group) in groups.enumerate() {
    let group-layout
    if util.is-arr(layout) {
      if layout.len() > i {
        group-layout = layout.at(i)
      } else {
        group-layout = layout.at(-1)
      }
    } else {
      group-layout = layout
    }

    let (pos, anc) = group-layout(
      spec + (states: group),
      position: if i == 0 {
        position
      } else {
        // TODO: (ngb) fix spacing between layouts
        (rel: (i * spacing, 0), to: position)
      },
      style: style,
    )

    positions += pos
    anchors += anc
  }

  return create-layout(positions: positions, anchors: anchors)
}


// cetz.draw.group(
//   name: name,
//   anchor: anchor,
//   ctx => {
//     let groups = ()
//     let rest = ()

//     let (_, elements) = util.resolve-zipped(ctx, body)

//     if util.is-int(grouping) {
//       for (i, (cetz-element, element)) in elements.enumerate() {
//         if calc.rem(i, grouping) == 0 {
//           groups.push(())
//         }
//         groups.last().push(cetz-element)
//       }
//     } else if util.is-arr(grouping) {
//       // Collect States into groups
//       for (group) in grouping {
//         groups.push(())
//         for (cetz-element, element) in elements {
//           if "name" in element and element.name in group {
//             groups.last().push(cetz-element)
//           }
//         }
//       }
//       for (cetz-element, element) in elements {
//         if "name" not in element or not grouping.any(g => element.name in g) {
//           rest.push(cetz-element)
//         }
//       }
//     }

//     let elements = ()
//     let last-name = none
//     for (i, group) in groups.enumerate() {
//       let group-layout
//       if util.is-arr(layout) {
//         if layout.len() > i {
//           group-layout = layout.at(i)
//         } else {
//           group-layout = layout.at(-1)
//         }
//       } else {
//         group-layout = layout
//       }


//       elements += group-layout(
//         if i == 0 {
//           position
//         } else {
//           (rel: (spacing, 0), to: "l" + str(i - 1) + ".east")
//         },
//         name: "l" + str(i),
//         anchor: "west",
//         group,
//       )
//       elements += cetz.draw.copy-anchors("l" + str(i))
//       elements += cetz.draw.rect("l" + str(i) + ".north-west", "l" + str(i) + ".south-east")
//       elements += cetz.draw.circle("l" + str(i) + ".west", radius: .2, fill: green)
//       elements += cetz.draw.circle("l" + str(i) + ".east", radius: .2, fill: red)
//     }

//     elements + rest
//   },
// )
