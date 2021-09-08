load("//flatbuffers:flatbuffers_lang_toolchain.bzl", "DEFAULT_FLATC", "flatbuffers_lang_toolchain")

DEFAULT_TOOLCHAIN = "@rules_flatbuffers//flatbuffers/toolchains:default_cc_flatbuffers_toolchain"

DEFAULT_FLATC_ARGS = [
    # Language flag
    "--cpp",
    # This is necessary to preserve the directory hierarchy for generated headers to be relative to
    # the workspace root as bazel expects.
    "--keep-prefix",
    # Some reasonable opinionated defaults.
    "--gen-compare",
    "--gen-mutable",
    "--gen-name-strings",
    "--reflect-names",
]

DEFAULT_RUNTIME = "@com_github_google_flatbuffers//:flatbuffers"

def cc_flatbuffers_toolchain(
        name,
        flatc = DEFAULT_FLATC,
        flatc_args = DEFAULT_FLATC_ARGS,
        runtime = DEFAULT_RUNTIME,
        visibility = None):
    flatbuffers_lang_toolchain(
        name = name,
        flatc = flatc,
        flatc_args = flatc_args,
        runtime = runtime,
        visibility = visibility,
    )
