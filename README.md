# rules_flatbuffers

Bazel rules for using google [Flatbuffers](https://github.com/google/flatbuffers)

For a list of releases and changes see the [CHANGELOG](CHANGELOG.md)

## Installing

Add the following lines to your WORKSPACE file to download and initialize rules_flatbuffers in your repo:

```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_flatbuffers",
    sha256 = "902e649b358846c762829e7aae78db346571ffed7f4a849deebf0f0f69fb398e",
    strip_prefix = "rules_flatbuffers-0.2.0",
    urls = ["https://github.com/kgreenek/rules_flatbuffers/archive/refs/tags/v0.2.0.tar.gz"],
)

load(
    "@rules_flatbuffers//flatbuffers:repositories.bzl",
    "flatbuffers_cc_toolchain",
    "flatbuffers_dependencies",
    "flatbuffers_toolchain",
)

flatbuffers_dependencies()

flatbuffers_toolchain()

flatbuffers_cc_toolchain()
```

## Usage

### Create a flatbuffers_library

These targets define the dependency relationships between your flatbuffers files, which is used by all the other language-specific rules.

```bzl
load("@rules_flatbuffers//flatbuffers:flatbuffers_library.bzl", "flatbuffers_library")

flatbuffers_library(
    name = "foo_fbs",
    srcs = ["foo.fbs"],
)
```

In order to import an fbs file from one flatbuffers_library from another fbs file in a different flatbuffers_library, the former must be listed in the deps of the latter.

For example, if we create a second fbs file called bar.fbs that includes foo.fbs, we might define a flatbuffers_library like so:

```bzl
flatbuffers_library(
    name = "bar_fbs",
    srcs = ["bar.fbs"],
    deps = [":foo_fbs"],
)
```

NOTE: You do not need to create a separate flatbuffers_library for each fbs source file. That is done here for illustration purposes. However, the more granularly you define your flatbuffers_libraries, the better bazel caching will be able to speed up your builds, since it can be smarter about only generating / compiling sources that are actually imported. 

### Create a C++ flatbuffers library

This is an example of creating a cc_flatbuffers_library target. This target generates the C++ headers using the flatc compiler, including resolving all transitive dependencies. This target can be used in the deps of any normal cc_library or cc_binary target.

```bzl
load("@rules_flatbuffers//flatbuffers:cc_flatbuffers_library.bzl", "cc_flatbuffers_library")

cc_flatbuffers_library(
    name = "foo_cc_fbs",
    deps = [":foo_fbs"],
)
```

Include paths for all generated C++ headers mirror the corresponding fbs file's location in the mono-repo. For example, if you create an fbs file called `//foo/bar/baz.fbs`, the generated C++ header will be included like so: `#include "foo/bar/baz_generated.h"`.

It is highly recommended to choose namespaces in your fbs files so that they match the bazel workspace hierarchy. This will create consistency in how you use the geneated files across all languages for which sources are generated.

In this case, the namespace in `//foo/bar/baz.fbs` would be declared as `namespace foo.bar;` and the generated C++ class / namespace would be e.g. `::foo::bar::Baz`

Language targets such as cc_flatbuffers_library can only depend on existing flatbuffers_library targets.

## Full examples

For full examples for all supported languages, browse through the [examples](examples) package.
