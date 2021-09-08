load("//flatbuffers:flatbuffers_lang_toolchain.bzl", "DEFAULT_FLATC", "flatbuffers_lang_toolchain")

DEFAULT_TOOLCHAIN = "//flatbuffers/toolchains:default_schema_flatbuffers_toolchain"

DEFAULT_LANG_SHORTNAME = "schema"
DEFAULT_FLATC_ARGS = ["-b", "--schema"]

def schema_flatbuffers_toolchain(
        name,
        lang_shortname = DEFAULT_LANG_SHORTNAME,
        flatc = DEFAULT_FLATC,
        flatc_args = DEFAULT_FLATC_ARGS,
        runtime = None,
        visibility = None):
    flatbuffers_lang_toolchain(
        name = name,
        lang_shortname = lang_shortname,
        flatc = flatc,
        flatc_args = flatc_args,
        runtime = runtime,
        visibility = visibility,
    )
