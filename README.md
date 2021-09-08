# rules_flatbuffers

Bazel rules for using google [Flatbuffers](https://github.com/google/flatbuffers)

For a list of release and changes, see the [CHANGELOG](CHANGELOG.md)

## Installing

Add the following lines to your WORKSPACE file to download and initialize rules_flatbuffers in your repo:

```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_flatbuffers",
    sha256 = "186cbab97e3346996dc07809e38e94eb23bcf3b292fc7df04e20580566e6e985",
    strip_prefix = "rules_flatbuffers-c85b17b21149f1a45a125eb8028a8526e4fd71be",
    urls = [https://github.com/kgreenek/rules_flatbuffers/archive/c85b17b21149f1a45a125eb8028a8526e4fd71be.tar.gz],
)

load("@rules_flatbuffers//flatbuffers:repositories.bzl", "flatbuffers_dependencies")

flatbuffers_dependencies()
```

## Usage

### Create a flatbuffers_library

These targets define the dependency relationships between your flatbuffers files, which is used by all the other language-specific rules. In order to import an fbs file from another fbs file, it must be in the same flatbuffers_library or be listed in the deps field of the parent flatbuffers_library.

```bzl
load("@rules_flatbuffers//flatbuffers:flatbuffers_library.bzl", "flatbuffers_library")

flatbuffers_library(
    name = "foo_fbs",
    srcs = ["foo.fbs"],
    visibility = ["//visibility:public"],
)
```

### Create a C++ flatbuffers library

This is an example of creating a cc_flatbuffers_library target. This target generates the C++ headers using the flatc compiler, including resolving all transitive dependencies. This target can be used in the deps of any normal cc_library or cc_binary target.

```bzl
load("@rules_flatbuffers//flatbuffers:cc_flatbuffers_library.bzl", "cc_flatbuffers_library")

cc_flatbuffers_library(
    name = "foo_cc_fbs",
    deps = [":foo_fbs"],
    visibility = ["//visibility:public"],
)
```

Include paths for all generated C++ headers mirror the corresponding fbs file's location in the mono-repo. For example, if you create an fbs file called `//foo/bar/baz.fbs`, the generated hC++ eader will be included like so: `#include "foo/bar/baz_generated.h`.

It is highly recommended to choose namespaces in your fbs files so that they match the bazel workspace hierarchy. This will create consistency in how you use the geneated files across all languages for which sources are generated.

In this case, the namespace in `//foo/bar/baz.fbs` would be declared as `namespace foo.bar;` and the generated C++ class / namespace would be e.g. `::foo::bar::Baz`

Language targets can only depend on existing flatbuffers libraries.

## Full examples

For full examples for all supported languages, browse through the [examples](examples) package.
