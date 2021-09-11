load("//flatbuffers/toolchain_defs:toolchain_defs.bzl", "toolchain_target_for_repo")

CC_LANG_REPO = "rules_flatbuffers_cc_toolchain"
CC_LANG_TOOLCHAIN = toolchain_target_for_repo(CC_LANG_REPO)
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
