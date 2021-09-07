FlatbuffersInfo = provider(fields = {
    "srcs": "srcs fbs files for this target (non-transitive)",
    "srcs_transitive": "depset of fbs files",
    "includes": "includes for this target",
    "includes_transitive": "depset of includes",
    "schema_files": "generated schema files from this target (non-transitive)",
    "schema_files_transitive": "depset of generated schema files",
})

DEFAULT_FLATC = "@com_github_google_flatbuffers//:flatc"
SCHEMA_FILE_EXTENSION = "bfbs"

def _replace_extension(string, old_extension, new_extension):
    return string.rpartition(old_extension)[0] + new_extension

def _flatbuffers_library_impl(ctx):
    srcs_depset = depset(
        direct = ctx.files.srcs,
        transitive = [dep[FlatbuffersInfo].srcs_transitive for dep in ctx.attr.deps],
    )
    includes_depset = depset(
        direct = ctx.attr.includes,
        transitive = [dep[FlatbuffersInfo].includes_transitive for dep in ctx.attr.deps],
    )
    schema_files = [
        ctx.actions.declare_file(_replace_extension(
            string = src.basename,
            old_extension = src.extension,
            new_extension = SCHEMA_FILE_EXTENSION,
        ))
        for src in ctx.files.srcs
    ]
    schema_files_depset = depset(
        direct = schema_files,
        transitive = [dep[FlatbuffersInfo].schema_files_transitive for dep in ctx.attr.deps],
    )

    # Always include the workspace root.
    include_args = ["-I", "."]
    for include in includes_depset.to_list():
        include_args.append("-I")
        include_args.append(include)
    schema_genrule_args = \
        ["-b", "--schema"] + \
        ["-o", ctx.genfiles_dir.path + "/" + ctx.label.package] + \
        include_args + \
        [src.path for src in ctx.files.srcs]
    ctx.actions.run(
        inputs = srcs_depset,
        outputs = schema_files,
        executable = ctx.executable._flatc,
        tools = [ctx.executable._flatc],
        arguments = schema_genrule_args,
        mnemonic = "FlatbuffersSchemaGen",
        progress_message = "Generating flatbuffers schema file for %s:" % (ctx.label),
    )
    return [
        DefaultInfo(files = schema_files_depset),
        FlatbuffersInfo(
            srcs = ctx.files.srcs,
            srcs_transitive = srcs_depset,
            includes = ctx.attr.includes,
            includes_transitive = includes_depset,
            schema_files = schema_files,
            schema_files_transitive = schema_files_depset,
        ),
    ]

flatbuffers_library = rule(
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = [FlatbuffersInfo]),
        "includes": attr.string_list(),
        "_flatc": attr.label(
            default = DEFAULT_FLATC,
            allow_single_file = True,
            cfg = "host",
            executable = True,
        ),
    },
    output_to_genfiles = True,
    implementation = _flatbuffers_library_impl,
)
"""Flatbuffers library

Args:
  
"""
