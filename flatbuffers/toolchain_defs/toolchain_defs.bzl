def toolchain_target_for_repo(repo):
    return "@" + repo + "//toolchain"

FLATBUFFERS_TOOLCHAIN_REPO = "rules_flatbuffers_toolchain"
FLATBUFFERS_TOOLCHAIN = toolchain_target_for_repo(FLATBUFFERS_TOOLCHAIN_REPO)
FLATBUFFERS_TOOLCHAIN_DEFAULT_FLATC = "@com_github_google_flatbuffers//:flatc"
