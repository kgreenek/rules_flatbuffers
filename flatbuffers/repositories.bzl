load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//flatbuffers/internal:flatbuffers_lang_toolchain_gen.bzl", "flatbuffers_lang_toolchain_gen")
load("//flatbuffers/internal:flatbuffers_toolchain_gen.bzl", "flatbuffers_toolchain_gen")
load(
    "//flatbuffers/toolchain_defs:cc_defs.bzl",
    "CC_LANG_DEFAULT_EXTRA_FLATC_ARGS",
    "CC_LANG_DEFAULT_RUNTIME",
    "CC_LANG_FLATC_ARGS",
    "CC_LANG_REPO",
    "CC_LANG_SHORTNAME",
)
load(
    "//flatbuffers/toolchain_defs:schema_defs.bzl",
    "SCHEMA_LANG_FLATC_ARGS",
    "SCHEMA_LANG_REPO",
    "SCHEMA_LANG_SHORTNAME",
)
load(
    "//flatbuffers/toolchain_defs:toolchain_defs.bzl",
    "FLATBUFFERS_TOOLCHAIN_DEFAULT_FLATC",
    "FLATBUFFERS_TOOLCHAIN_REPO",
)

def flatbuffers_dependencies():
    maybe(
        http_archive,
        name = "com_github_google_flatbuffers",
        sha256 = "9ddb9031798f4f8754d00fca2f1a68ecf9d0f83dfac7239af1311e4fd9a565c4",
        strip_prefix = "flatbuffers-2.0.0",
        urls = [
            # TODO(kgreenek): Mirror this somewhere in case github is down.
            # Ideally mirror.bazel.build (ping @philwo on github).
            "https://github.com/google/flatbuffers/archive/refs/tags/v2.0.0.tar.gz",
        ],
    )

def flatbuffers_toolchain(flatc = FLATBUFFERS_TOOLCHAIN_DEFAULT_FLATC):
    flatbuffers_toolchain_gen(
        name = FLATBUFFERS_TOOLCHAIN_REPO,
        flatc = flatc,
    )
    flatbuffers_lang_toolchain_gen(
        name = SCHEMA_LANG_REPO,
        lang_shortname = SCHEMA_LANG_SHORTNAME,
        flatc_args = SCHEMA_LANG_FLATC_ARGS,
    )

def flatbuffers_cc_toolchain(
        runtime = CC_LANG_DEFAULT_RUNTIME,
        extra_flatc_args = CC_LANG_DEFAULT_EXTRA_FLATC_ARGS):
    flatbuffers_lang_toolchain_gen(
        name = CC_LANG_REPO,
        lang_shortname = CC_LANG_SHORTNAME,
        flatc_args = CC_LANG_FLATC_ARGS + extra_flatc_args,
        runtime = runtime,
    )
