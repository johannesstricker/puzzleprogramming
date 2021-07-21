# PuzzleProgramming

[![Tests](https://github.com/johannesstricker/puzzleprogramming/actions/workflows/continuous-integration.yml/badge.svg)](https://github.com/johannesstricker/puzzleprogramming/actions/workflows/continuous-integration.yml)

C++ project template using [cmake](https://cmake.org/) and [vcpkg](https://github.com/microsoft/vcpkg).

## Roadmap

- [ ] Create `puzzlelib.podspec`
- [ ] Link `puzzle_plugin` to `puzzlelib.podspec` podspec
- [ ]

## Building the project
The project is build with cmake and vcpkg. Make sure that you have [cmake](https://cmake.org/) and [vcpkg](https://github.com/microsoft/vcpkg) installed and added to your path. Additionally, point the `VCPKG_ROOT` environment variable to the vcpkg root directory. Then you can build by running
```
cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"
cmake --build build
```
from the project root. Alternatively, you can build the project from vscode with the [CMake Tools Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools). If cmake cannot find a vcpkg package it might help to delete the `CMakeCache.txt` in the build directory.

## Dependencies
To add additional project dependencies just add them to the `dependencies` entry in the `vcpkg.json` file.
```
{
  "name": "cpp-project-template",
  "version-string": "0.0.1",
  "dependencies": [
    "catch2",
    "qt5",
    "sqlite3"
  ]
}
```
