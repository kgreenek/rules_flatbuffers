DEFAULT_FLATC = "@com_github_google_flatbuffers//:flatc"

FlatbuffersLangToolchainInfo = provider(fields = {
    "lang_shortname": "short name for the toolchain / language, e.g. 'cc', 'java', 'rust', etc.",
    "flatc_args": "args to pass to flatc",
    "runtime": "language-dependent runtime target to e.g. link with compiled libraries",
})

def _flatbuffers_lang_toolchain_impl(ctx):
    return FlatbuffersLangToolchainInfo(
        lang_shortname = ctx.attr.lang_shortname,
        flatc_args = ctx.attr.flatc_args,
        runtime = ctx.attr.runtime,
    )

flatbuffers_lang_toolchain = rule(
    implementation = _flatbuffers_lang_toolchain_impl,
    attrs = {
        "lang_shortname": attr.string(),
        "flatc_args": attr.string_list(),
        "runtime": attr.label(
            cfg = "exec",
        ),
    },
)
