# Release Compliance Notes

This document records the license and distribution rules for Paper Mario ReCut release packages.

## Corrective Release

Version `v0.1.2` is a license-compliance corrective release. Its purpose is to publish the missing root license, third-party notices, build/source notes, and bundled dependency license files that should accompany public binary distributions.

This release does not change the ROM requirement. Paper Mario ReCut still requires each user to provide their own legally obtained Paper Mario (U) ROM. The launcher validates that ROM locally and stores user runtime data under that installation's local `user/` folder.

## What Public Releases Must Exclude

Do not include any of the following in a public release package:

- ROM files or copied ROMs.
- Save files, save states, or user folders.
- Generated recompilation output derived from a local ROM.
- Generated TOML or other local build output.
- Texture dumps or user-supplied texture replacement packs.

## Source Availability

The GitHub tag for each release is the source snapshot for Paper Mario ReCut's original code and bundled source dependencies at that release.

Because the Windows binary links against N64ModernRuntime, release packages should include the GPLv3 text from `lib/N64ModernRuntime/COPYING` and direct users to the tagged source archive for the corresponding source. If any source dependency is provided through a submodule, the release source instructions should tell builders to initialize submodules before building.

## Binary Package Checklist

Before publishing a Windows release zip:

1. Build from a clean source checkout or a known clean build directory.
2. Stage only the executable, required runtime DLLs, assets that have approved provenance, README, and license/notice files.
3. Add a `licenses/` folder containing the dependency licenses listed in `THIRD_PARTY_NOTICES.md`.
4. Confirm the staged package has no `user/`, ROM, save, dump, or generated recomp output folders.
5. Name the GitHub release and release notes clearly when the release exists for license compliance.

## Current Known Follow-Up

The built-in texture replacement assets in `assets/builtin_textures/` should keep documented provenance before future non-compliance releases. They must remain original, authorized, or otherwise legally distributable; they must not be copied from the Paper Mario ROM.
