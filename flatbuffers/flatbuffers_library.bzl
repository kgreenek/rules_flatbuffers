load("//flatbuffers:flatbuffers_lang_toolchain.bzl", "FlatbuffersLangToolchainInfo")
load("//flatbuffers/private:run_flatc.bzl", "run_flatc")
load("//flatbuffers/private:string_utils.bzl", "replace_extension")
load("//flatbuffers/toolchains:schema_flatbuffers_toolchain.bzl", "DEFAULT_TOOLCHAIN")

FlatbuffersInfo = provider(fields = {
    "srcs": "srcs fbs files for this target (non-transitive)",
    "srcs_transitive": "depset of fbs files",
    "includes": "includes for this target",
    "includes_transitive": "depset of includes",
    "schema_files": "generated schema files from this target (non-transitive)",
    "schema_files_transitive": "depset of generated schema files",
})

SCHEMA_FILE_EXTENSION = "bfbs"

def _flatbuffers_library_impl(ctx):
    srcs_transitive = depset(
        direct = ctx.files.srcs,
        transitive = [dep[FlatbuffersInfo].srcs_transitive for dep in ctx.attr.deps],
    )
    includes_transitive = depset(
        direct = ctx.attr.includes,
        transitive = [dep[FlatbuffersInfo].includes_transitive for dep in ctx.attr.deps],
    )
    schema_files = [
        ctx.actions.declare_file(replace_extension(
            string = src.basename,
            old_extension = src.extension,
            new_extension = SCHEMA_FILE_EXTENSION,
        ))
        for src in ctx.files.srcs
    ]
    schema_files_transitive = depset(
        direct = schema_files,
        transitive = [dep[FlatbuffersInfo].schema_files_transitive for dep in ctx.attr.deps],
    )
    run_flatc(
        ctx = ctx,
        toolchain = ctx.attr._toolchain[FlatbuffersLangToolchainInfo],
        srcs = ctx.files.srcs,
        srcs_transitive = srcs_transitive,
        includes_transitive = includes_transitive,
        outputs = schema_files,
    )

    return [
        DefaultInfo(
            files = schema_files_transitive,
            runfiles = ctx.runfiles(
                files = schema_files,
                transitive_files = schema_files_transitive,
            ),
        ),
        FlatbuffersInfo(
            srcs = ctx.files.srcs,
            srcs_transitive = srcs_transitive,
            includes = ctx.attr.includes,
            includes_transitive = includes_transitive,
            schema_files = schema_files,
            schema_files_transitive = schema_files_transitive,
        ),
    ]

flatbuffers_library = rule(
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = [FlatbuffersInfo]),
        "includes": attr.string_list(),
        "_toolchain": attr.label(
            providers = [FlatbuffersLangToolchainInfo],
            default = DEFAULT_TOOLCHAIN,
        ),
    },
    output_to_genfiles = True,
    implementation = _flatbuffers_library_impl,
)
