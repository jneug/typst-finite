root := justfile_directory()
package-fork := x'${TYPST_PKG_FORK:-}'
export TYPST_ROOT := root

[private]
default:
    @just --list --unsorted

# build assets
assets:
    typst compile docs/assets/example.typ docs/assets/example.svg
    typst compile --input theme=dark docs/assets/example.typ docs/assets/example-dark.svg
    typst compile docs/assets/finite-logo.typ docs/assets/finite-logo.svg
    typst compile --input theme=dark docs/assets/finite-logo.typ docs/assets/finite-logo-dark.svg

# generate manual
doc: assets
    typst compile docs/manual.typ docs/manual.pdf

# run test suite
test *args:
    tt run {{ args }}

# update test cases
update *args:
    tt update {{ args }}

# package the library into the specified destination folder
package target:
    ./scripts/package "{{ target }}"

# install the library with the "@local" prefix
install: (package "@local")

# install the library with the "@preview" prefix (for pre-release testing)
install-preview: (package "@preview")

[private]
[working-directory(x'${TYPST_PKG_FORK:-.}')]
prepare-fork:
    git checkout main
    git pull typst main
    git push origin --force

prepare: prepare-fork (package package-fork)

# create a symbolic link to this library in the target repository
link target="@local":
    ./scripts/link "{{ target }}"

link-preview: (link "@preview")

[private]
remove target:
    ./scripts/uninstall "{{ target }}"

# uninstalls the library from the "@local" prefix
uninstall: (remove "@local")

# uninstalls the library from the "@preview" prefix (for pre-release testing)
uninstall-preview: (remove "@preview")

# unlinks the library from the "@local" prefix
unlink: (remove "@local")

# unlinks the library from the "@preview" prefix
unlink-preview: (remove "@preview")

# run ci suite
ci: test doc
