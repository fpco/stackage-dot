# stackage-dot

Visualize a Haskell project's dependency graph using Graphviz `dot`.

## Usage

With `stackage-build`, multiple packages can't be grouped into
a project using the `stackage-build.config` file. `stackage-dot` shows
the dependency graph between each package listed in
`stackage-build.config`. If `stackage-cli` is installed, then usage is
as follows:

```Shell
$ cd /path/to/project
$ stackage dot > graph.dot
$ dot -Tpng < graph.dot > graph.png
```

