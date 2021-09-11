# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

IMPORTANT: Prior to 1.0.0, minor versions may contain API-breaking changes.

## [Unreleased]

## [0.2.0] - 2021-09-11
### Added
- Add .bazelversion file to cc_example
### Changed
- Refactor toolchains so they are configured in repository context in the WORKSPACE
- Factor common code into run_flatc function
- Add lang_shortname to FlatbuffersLangToolchain provider
### Removed
- Remove toolchain arg from cc_flatbuffers_library rule
- Remove gen-compare flag from cc toolchain
### Fixed
- Properly add generated schema files to runfiles

## [0.1.0] - 2021-09-07
### Added
- FlatbuffersLangToolchain implementation for customizing rule behavior
- flatbuffer_library rule implementation
- cc_flatbuffer_library rule and cc_flatbuffer_toolchain implementation

