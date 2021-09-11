def _flatbuffers_toolchain_gen_impl(ctx):
    ctx.template(
        "toolchain/BUILD.bazel",
        ctx.attr._build_tpl,
        substitutions = {
            "{flatc}": str(ctx.attr.flatc),
        },
    )

flatbuffers_toolchain_gen = repository_rule(
    implementation = _flatbuffers_toolchain_gen_impl,
    attrs = {
        "flatc": attr.label(
            allow_single_file = True,
            cfg = "host",
            executable = True,
        ),
        "_build_tpl": attr.label(
            default = "@rules_flatbuffers//flatbuffers/private:BUILD.toolchain.tpl",
        ),
    },
    doc = "Creates the Flatbuffer toolchain that will be used by all flatbuffer_library targets",
)
