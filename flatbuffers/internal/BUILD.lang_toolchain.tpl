load(
    "@rules_flatbuffers//flatbuffers/internal:flatbuffers_lang_toolchain.bzl",
    "flatbuffers_lang_toolchain",
)

flatbuffers_lang_toolchain(
    name = "toolchain",
    lang_shortname = "{lang_shortname}",
    flatc_args = [{flatc_args}],
    {runtime}
    visibility = ["//visibility:public"],
)

