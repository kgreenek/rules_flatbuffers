load("@rules_flatbuffers//flatbuffers/internal:flatbuffers_toolchain.bzl", "flatbuffers_toolchain")

flatbuffers_toolchain(
    name = "toolchain",
    flatc = "{flatc}",
    visibility = ["//visibility:public"],
)
