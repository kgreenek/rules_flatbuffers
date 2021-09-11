load("//flatbuffers/internal:string_utils.bzl", "capitalize_first_char")

def _include_args_from_depset(includes_depset):
    # Always include the workspace root.
    include_args = ["-I", "."]
    for include in includes_depset.to_list():
        include_args.append("-I")
        include_args.append(include)
    return include_args

def run_flatc(
        ctx,
        fbs_toolchain,
        fbs_lang_toolchain,
        srcs,
        srcs_transitive,
        includes_transitive,
        outputs):
    flatc = fbs_toolchain.flatc.files_to_run.executable
    include_args = _include_args_from_depset(includes_transitive)
    output_prefix = ctx.genfiles_dir.path + "/" + ctx.label.package
    mnemonic = "Flatbuffers{}Gen".format(capitalize_first_char(fbs_lang_toolchain.lang_shortname))
    progress_message = "Generating flatbuffers {} file for {}:".format(
        fbs_lang_toolchain.lang_shortname,
        ctx.label,
    )
    genrule_args = \
        fbs_lang_toolchain.flatc_args + \
        ["-o", output_prefix] + \
        include_args + \
        [src.path for src in srcs]
    ctx.actions.run(
        inputs = srcs_transitive,
        outputs = outputs,
        executable = flatc,
        tools = [flatc],
        arguments = genrule_args,
        mnemonic = mnemonic,
        progress_message = progress_message,
    )
