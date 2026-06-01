# Third-Party Notices

Paper Mario ReCut contains original project code plus integrations with third-party open-source projects. The root `LICENSE` applies only to Paper Mario ReCut's original project code. Third-party components remain under their own license terms.

This repository and its releases do not grant rights to Nintendo, Intelligent Systems, the Paper Mario ROM, Paper Mario game assets, trademarks, or other copyrighted game material. Public release packages must not include ROMs, save files, user folders, generated ROM-derived output, dumped textures, or locally supplied replacement packs. Users must provide their own legally obtained Paper Mario (U) ROM when the launcher asks for it.

## Core Runtime And Tooling

- N64ModernRuntime is included under `lib/N64ModernRuntime`. Its `COPYING` file contains the GNU General Public License, version 3. Binary distributions that include or link this runtime should include that license and provide the corresponding source for the shipped version.
- N64Recomp is included under `lib/N64ModernRuntime/N64Recomp` and carries its own MIT license in `lib/N64ModernRuntime/N64Recomp/LICENSE`.
- RT64 is included under `lib/rt64` and carries its own MIT license in `lib/rt64/LICENSE`.
- SDL2 is used for windowing, input, controller, and audio support. Windows release builds fetch the SDL2 development package during CMake configuration; the SDL2 zlib-style notice from that package must be bundled with binary releases that include `SDL2.dll`.
- Microsoft DirectX Shader Compiler files, including `dxcompiler.dll` and `dxil.dll`, are redistributed from RT64's DXC dependency. DirectXShaderCompiler is distributed under the University of Illinois Open Source License with third-party notices in the upstream project.
- Paper Atlas Tool is the bundled texture editing sidecar under `tools/PaperAtlasTool`. Its original project code is covered by this repository's root `LICENSE` unless a file states otherwise.

## Additional Bundled Dependencies

The `lib/` tree includes additional dependencies used by N64ModernRuntime, N64Recomp, RT64, and their build tooling. Their notices are kept with the source under their respective directories, including but not limited to:

- `lib/N64ModernRuntime/thirdparty/`
- `lib/N64ModernRuntime/N64Recomp/lib/`
- `lib/rt64/src/contrib/`

Keep those notices intact when distributing source archives or binary packages.

## Release Package Notice Checklist

A public Windows release package should include at least:

- `LICENSE`
- `THIRD_PARTY_NOTICES.md`
- `COMPLIANCE.md`
- `licenses/N64ModernRuntime-COPYING-GPLv3.txt`
- `licenses/N64Recomp-LICENSE-MIT.txt`
- `licenses/RT64-LICENSE-MIT.txt`
- `licenses/SDL2-COPYING.txt`
- `licenses/DXC-LICENSE.txt`
- `licenses/DXC-ThirdPartyNotices.txt`, when available from the DXC source or binary package used

Do not include local `user/` folders, ROMs, save data, generated recomp output, or texture dumps in public release packages.
