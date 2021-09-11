load("//flatbuffers/toolchain_defs:toolchain_defs.bzl", "toolchain_target_for_repo")

SCHEMA_LANG_REPO = "rules_flatbuffers_schema_toolchain"
SCHEMA_LANG_TOOLCHAIN = toolchain_target_for_repo(SCHEMA_LANG_REPO)
SCHEMA_LANG_SHORTNAME = "schema"
SCHEMA_LANG_FLATC_ARGS = ["-b", "--schema"]
