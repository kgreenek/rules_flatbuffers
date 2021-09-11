def _flatbuffers_lang_toolchain_gen_impl(ctx):
    flatc_args_str = ",".join([("\"" + flatc_arg + "\"") for flatc_arg in ctx.attr.flatc_args])
    runtime_str = "" if not ctx.attr.runtime else "runtime = \"" + str(ctx.attr.runtime) + "\","
    ctx.template(
        "toolchain/BUILD.bazel",
        ctx.attr._build_tpl,
        substitutions = {
            "{lang_shortname}": ctx.attr.lang_shortname,
            "{flatc_args}": flatc_args_str,
            "{runtime}": runtime_str,
        },
    )

flatbuffers_lang_toolchain_gen = repository_rule(
    implementation = _flatbuffers_lang_toolchain_gen_impl,
    attrs = {
        "lang_shortname": attr.string(),
        "flatc_args": attr.string_list(),
        "runtime": attr.string(),
        "_build_tpl": attr.label(
            default = "@rules_flatbuffers//flatbuffers/internal:BUILD.lang_toolchain.tpl",
        ),
    },
    doc = "Creates the Flatbuffer toolchain that will be used by all flatbuffer_library targets",
)

