# PuzzleProgramming

![PuzzleMath](https://github.com/johannesstricker/puzzleprogramming/actions/workflows/puzzlemath.yml/badge.svg)
![PuzzlePlugin](https://github.com/johannesstricker/puzzleprogramming/actions/workflows/puzzleplugin.yml/badge.svg)
![PuzzleLib](https://github.com/johannesstricker/puzzleprogramming/actions/workflows/puzzlelib.yml/badge.svg)

Flutter app for block-like programming with physical puzzle pieces. Only math expressions are supported at the moment.

## Build

### PuzzleMath

Inside the `puzzlemath/` folder you can use
```
flutter run
```
to build and run the app. Alternatively, use the Flutter extension for vscode and run the app directly from the editor.

### PuzzleLib

You can build the puzzlelib project in isolation with cmake and vcpkg. Make sure that you have [cmake](https://cmake.org/) and [vcpkg](https://github.com/microsoft/vcpkg) installed and added to your path. Additionally, point the `VCPKG_ROOT` environment variable to the vcpkg root directory. Then you can build by running
```
cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"
cmake --build build
```
from the `puzzlelib/` directory. Alternatively, you can build the project from vscode with the [CMake Tools Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools).

## Roadmap

- [ ] Write tests for flutter math parsing
- [ ] Remove unused code from C-Library
- [ ] Implement challenges
- [ ] Implement error hints