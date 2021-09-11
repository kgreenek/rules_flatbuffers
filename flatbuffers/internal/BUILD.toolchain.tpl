load("@rules_flatbuffers//flatbuffers:flatbuffers_toolchain.bzl", "flatbuffers_toolchain")

flatbuffers_toolchain(
    name = "toolchain",
    flatc = "{flatc}",
    visibility = ["//visibility:public"],
)
