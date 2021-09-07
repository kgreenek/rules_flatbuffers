load(
    "@rules_flatbuffers//flatbuffers:flatbuffers_lang_toolchain.bzl",
    "FlatbuffersLangToolchainInfo",
)
load("@rules_flatbuffers//flatbuffers:flatbuffers_library.bzl", "FlatbuffersInfo")
load(
    "@rules_flatbuffers//flatbuffers/toolchains:cc_flatbuffers_toolchain.bzl",
    "DEFAULT_TOOLCHAIN",
)

DEFAULT_SUFFIX = "_generated"
CC_HEADER_FILE_EXTENSION = "h"

FlatbuffersCcInfo = provider(fields = {
    "headers": "header files for this target (non-transitive)",
    "headers_transitive": "depset of generated headers",
    "includes": "includes for this target (non-transitive)",
    "includes_transitive": "depset of includes",
})

def _cc_filename(string, old_extension, new_extension, suffix):
    return string.rpartition(old_extension)[0][:-1] + suffix + "." + new_extension

def _flatbuffers_cc_info_aspect_impl(target, ctx):
    toolchain = ctx.attr._toolchain[FlatbuffersLangToolchainInfo]
    flatc = toolchain.flatc.files_to_run.executable
    headers = [
        ctx.actions.declare_file(_cc_filename(
            string = src.basename,
            old_extension = src.extension,
            new_extension = CC_HEADER_FILE_EXTENSION,
            suffix = DEFAULT_SUFFIX,
        ))
        for src in target[FlatbuffersInfo].srcs
    ]
    headers_depset = depset(
        direct = headers,
        transitive = [dep[FlatbuffersCcInfo].headers_transitive for dep in ctx.rule.attr.deps],
    )

    # Always include the workspace root.
    include_args = ["-I", "."]
    for dep in ctx.rule.attr.deps:
        for include in dep[FlatbuffersInfo].includes_transitive.to_list():
            include_args.append("-I")
            include_args.append(include)
    genrule_args = \
        toolchain.flatc_args + \
        ["-o", ctx.genfiles_dir.path + "/" + ctx.label.package] + \
        include_args + \
        [src.path for src in target[FlatbuffersInfo].srcs]
    ctx.actions.run(
        inputs = target[FlatbuffersInfo].srcs_transitive,
        outputs = headers,
        executable = flatc,
        tools = [flatc],
        arguments = genrule_args,
        mnemonic = "FlatbuffersCcGen",
        progress_message = "Generating flatbuffers cc headers for %s:" % (ctx.label),
    )

    # NOTE: It just so happens that we can re-use the flatbuffer includes for our cc target too.
    return FlatbuffersCcInfo(
        headers = headers,
        headers_transitive = headers_depset,
        includes = target[FlatbuffersInfo].includes,
        includes_transitive = target[FlatbuffersInfo].includes_transitive,
    )

def _cc_flatbuffers_genrule_impl(ctx):
    toolchain = ctx.attr.toolchain[FlatbuffersLangToolchainInfo]
    headers_depset = depset(
        transitive = [dep[FlatbuffersCcInfo].headers_transitive for dep in ctx.attr.deps],
    )
    includes_depset = depset(
        transitive = [dep[FlatbuffersCcInfo].includes_transitive for dep in ctx.attr.deps],
    )
    cc_info = CcInfo(
        compilation_context = cc_common.create_compilation_context(
            headers = headers_depset,
            includes = includes_depset,
        ),
    )
    return [
        cc_common.merge_cc_infos(
            direct_cc_infos = [cc_info],
            cc_infos = [toolchain.runtime[CcInfo]],
        ),
    ]

flatbuffers_cc_info_aspect = aspect(
    implementation = _flatbuffers_cc_info_aspect_impl,
    attr_aspects = ["deps"],
    attrs = {
        "_toolchain": attr.label(
            providers = [FlatbuffersLangToolchainInfo],
            default = DEFAULT_TOOLCHAIN,
        ),
    },
)

cc_flatbuffers_genrule = rule(
    attrs = {
        "deps": attr.label_list(
            aspects = [flatbuffers_cc_info_aspect],
            providers = [FlatbuffersInfo],
        ),
        "toolchain": attr.label(
            providers = [FlatbuffersLangToolchainInfo],
            default = DEFAULT_TOOLCHAIN,
        ),
    },
    output_to_genfiles = True,
    implementation = _cc_flatbuffers_genrule_impl,
)

def cc_flatbuffers_library(name, deps, toolchain = DEFAULT_TOOLCHAIN, **kwargs):
    genrule_name = name + "_genrule"
    cc_flatbuffers_genrule(
        name = genrule_name,
        deps = deps,
        toolchain = toolchain,
    )
    native.cc_library(
        name = name,
        deps = [":" + genrule_name],
        **kwargs
    )
