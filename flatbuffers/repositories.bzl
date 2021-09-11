load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//flatbuffers/internal:flatbuffers_lang_toolchain_gen.bzl", "flatbuffers_lang_toolchain_gen")
load("//flatbuffers/internal:flatbuffers_toolchain_gen.bzl", "flatbuffers_toolchain_gen")

DEFAULT_FLATC = "@com_github_google_flatbuffers//:flatc"

FLATBUFFERS_TOOLCHAIN_REPO = "rules_flatbuffers_toolchain"
FLATBUFFERS_TOOLCHAIN = "@" + FLATBUFFERS_TOOLCHAIN_REPO + "//toolchain"

SCHEMA_LANG_REPO = "rules_flatbuffers_schema_toolchain"
SCHEMA_LANG_TOOLCHAIN = "@" + SCHEMA_LANG_REPO + "//toolchain"
SCHEMA_LANG_SHORTNAME = "schema"
SCHEMA_LANG_FLATC_ARGS = ["-b", "--schema"]

CC_LANG_REPO = "rules_flatbuffers_cc_toolchain"
CC_LANG_TOOLCHAIN = "@" + CC_LANG_REPO + "//toolchain"
CC_LANG_SHORTNAME = "cc"
CC_LANG_DEFAULT_RUNTIME = "@com_github_google_flatbuffers//:flatbuffers"
CC_LANG_FLATC_ARGS = [
    "--cpp",
    # This is necessary to preserve the directory hierarchy for generated headers to be relative to
    # the workspace root as bazel expects.
    "--keep-prefix",
]
CC_LANG_DEFAULT_EXTRA_FLATC_ARGS = [
    "--gen-mutable",
    "--gen-name-strings",
    "--reflect-names",
]

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

def flatbuffers_toolchain(flatc = DEFAULT_FLATC):
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
