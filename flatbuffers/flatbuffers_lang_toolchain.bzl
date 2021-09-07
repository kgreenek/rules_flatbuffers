DEFAULT_FLATC = "@com_github_google_flatbuffers//:flatc"

FlatbuffersLangToolchainInfo = provider(fields = {
    "flatc": "flatc compiler target",
    "flatc_args": "args to pass to flatc",
    "runtime": "language-dependent runtime target to e.g. link with compiled libraries",
})

def _flatbuffers_lang_toolchain_impl(ctx):
    return FlatbuffersLangToolchainInfo(
        flatc = ctx.attr.flatc,
        flatc_args = ctx.attr.flatc_args,
        runtime = ctx.attr.runtime,
    )

flatbuffers_lang_toolchain = rule(
    implementation = _flatbuffers_lang_toolchain_impl,
    attrs = {
        "flatc": attr.label(
            default = DEFAULT_FLATC,
            allow_single_file = True,
            cfg = "host",
            executable = True,
        ),
        "flatc_args": attr.string_list(),
        "runtime": attr.label(
            cfg = "exec",
        ),
    },
)
