![finite-logo](docs/assets/finite-logo.svg)

[![Typst Package](https://img.shields.io/badge/dynamic/toml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fjneug%2Ftypst-finite%2Frefs%2Fheads%2Fmain%2Ftypst.toml&query=%24.package.version&prefix=v&logo=typst&label=package&color=239DAD)](https://typst.app/universe/package/finite)
[![MIT License](https://img.shields.io/badge/license-MIT-blue)](https://github.com/lilaq-project/lilaq/blob/main/LICENSE)

**finite** is a [Typst](https://github.com/typst/typst) package for rendering finite automata on top of [CeTZ](https://github.com/johannes-wolf/typst-canvas).

---

## Usage

Import the package from the Typst preview repository:

```typst
#import "@preview/finite:0.5.0": automaton
```

After importing the package, simply call `#automaton()` with a dictionary holding a transition table:
```typst
#import "@preview/finite:0.5.0": automaton

#automaton((
  q0: (q1:0, q0:"0,1"),
  q1: (q0:(0,1), q2:"0"),
  q2: (),
))
```

The output should look like this:
![Example for a finite automaton drawn with finite](docs/assets/example.png)

## Further documentation

See `manual.pdf` for a full manual of the package.
