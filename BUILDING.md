# Building Paper Mario ReCut

Paper Mario ReCut follows the same broad source/build model as other N64 recompilation projects:

1. The GitHub repository does not store ROMs, save files, user folders, or generated ROM-derived output.
2. A builder supplies their own legally obtained Paper Mario (U) ROM locally.
3. The builder generates `generated/paper_mario_recomp_out/` locally from their own ROM/decompilation workflow.
4. CMake builds the native Windows app from that local generated output.
5. Release/player packages ask each user to select their own ROM at launch. Players do not need CMake, WSL, Git, Visual Studio, or .NET to run a prepared release folder.

The generated output is local-only and must not be committed or placed in public release zips.

## Requirements

Windows is the supported build host right now.

- Git for Windows.
- Visual Studio 2022 with Desktop development with C++.
- CMake, either standalone or the Visual Studio CMake tools.
- .NET 8 SDK, used to publish `PaperAtlasTool.exe`.
- A legally obtained Paper Mario (U) ROM.
- Local Paper Mario recomp output at `generated/paper_mario_recomp_out/`.

## Clone

Clone the repository with submodules:

```powershell
git clone --recurse-submodules https://github.com/SmokeyMcGames/Paper-Mario-ReCut.git
cd Paper-Mario-ReCut
```

If you already cloned without submodules:

```powershell
git submodule update --init --recursive
```

## Generate Local Recomp Output

Before CMake can configure, `generated/paper_mario_recomp_out/lookup.cpp` must exist. Generate the `generated/paper_mario_recomp_out/` folder locally from your own legally obtained Paper Mario (U) ROM and local Paper Mario decompilation/recompilation workflow.

Do not commit `generated/paper_mario_recomp_out/`. Do not copy it into public release packages.

## Build The App

After `generated/paper_mario_recomp_out/` exists, configure and build:

```powershell
cmake -S . -B build-recut -G "Visual Studio 17 2022" -A x64 -DPAPER_MARIO_ROM_PATH="D:\path\to\Paper Mario (U).z64"
cmake --build build-recut --config Release --target PaperMarioReCut
```

The output will be in:

```text
build-recut/Release/
```

For a portable test folder, keep these files together:

```text
PaperMarioReCut.exe
SDL2.dll
dxcompiler.dll
dxil.dll
PaperAtlasTool.exe
assets/
README.md
LICENSE
THIRD_PARTY_NOTICES.md
COMPLIANCE.md
licenses/
```

Do not copy ROMs, saves, `generated/`, texture dumps, or `user/` into a public release.

## Running

Launch `PaperMarioReCut.exe`. The launcher asks for the supported Paper Mario (U) ROM, validates it locally, and stores runtime data under the installation's local `user/` folder.

Players do not need build tools to run a prepared release folder.

## Troubleshooting

If CMake says `generated/paper_mario_recomp_out/lookup.cpp` is missing, generate the local recomp output first.

If CMake cannot find a submodule dependency, run:

```powershell
git submodule update --init --recursive
```

If `PaperAtlasTool.exe` is missing from the build output, install the .NET 8 SDK and rebuild.
