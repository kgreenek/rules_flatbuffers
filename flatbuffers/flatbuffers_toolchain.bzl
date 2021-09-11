DEFAULT_FLATC = "@com_github_google_flatbuffers//:flatc"

FlatbuffersToolchainInfo = provider(fields = {
    "flatc": "flatc compiler target",
})

def _flatbuffers_toolchain_impl(ctx):
    return FlatbuffersToolchainInfo(
        flatc = ctx.attr.flatc,
    )

flatbuffers_toolchain = rule(
    implementation = _flatbuffers_toolchain_impl,
    attrs = {
        "flatc": attr.label(
            default = DEFAULT_FLATC,
            allow_single_file = True,
            cfg = "host",
            executable = True,
        ),
    },
)
