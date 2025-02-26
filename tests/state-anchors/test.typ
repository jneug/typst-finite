#import "../../src/finite.typ"

#set page(width: auto, height: auto, margin: 1cm)

#finite.cetz.canvas({
  import finite.cetz.draw: *
  import finite.draw: *
  import "../test-utils.typ": dot

  let name = "q0"
  let anchor = "west"

  state((0, 0), name, initial: true, anchor: anchor)

  for-each-anchor(
    name,
    exclude: ("initial",),
    anchor => {
      dot(name + "." + anchor)
    },
  )
  dot(name + ".initial.start")
  dot(name + ".initial.end")
})

#pagebreak()

#finite.cetz.canvas({
  import finite.cetz.draw: *
  import finite.draw: *
  import "../test-utils.typ": dot

  let name = "q0"
  let anchor = "west"

  state((0, 0), name, final: true, anchor: anchor)

  for-each-anchor(
    name,
    exclude: ("initial",),
    anchor => {
      dot(name + "." + anchor)
    },
  )
})
