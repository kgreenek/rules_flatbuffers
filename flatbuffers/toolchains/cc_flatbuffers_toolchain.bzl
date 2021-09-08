load("//flatbuffers:flatbuffers_lang_toolchain.bzl", "DEFAULT_FLATC", "flatbuffers_lang_toolchain")

DEFAULT_TOOLCHAIN = "//flatbuffers/toolchains:default_cc_flatbuffers_toolchain"

DEFAULT_LANG_SHORTNAME = "cc"
DEFAULT_RUNTIME = "@com_github_google_flatbuffers//:flatbuffers"
DEFAULT_FLATC_ARGS = [
    # Language flag
    "--cpp",
    # This is necessary to preserve the directory hierarchy for generated headers to be relative to
    # the workspace root as bazel expects.
    "--keep-prefix",
    # Some reasonable opinionated defaults.
    "--gen-mutable",
    "--gen-name-strings",
    "--reflect-names",
]


def cc_flatbuffers_toolchain(
        name,
        lang_shortname = DEFAULT_LANG_SHORTNAME,
        flatc = DEFAULT_FLATC,
        flatc_args = DEFAULT_FLATC_ARGS,
        runtime = DEFAULT_RUNTIME,
        visibility = None):
    flatbuffers_lang_toolchain(
        name = name,
        lang_shortname = lang_shortname,
        flatc = flatc,
        flatc_args = flatc_args,
        runtime = runtime,
        visibility = visibility,
    )
