<h1 align="center">Pico Build Action</h1>

![banner](.github/images/logo_dark.png#gh-dark-mode-only)
![banner](.github/images/logo_light.png#gh-light-mode-only)

<p align='center'>
    <a href='https://github.com/samyarsadat/Pico-Build-Action/blob/main/LICENSE'><img src='https://img.shields.io/github/license/samyarsadat/Pico-Build-Action'></a>
    |
    <a href='https://github.com/samyarsadat/Pico-Build-Action/issues'><img src='https://img.shields.io/github/issues/samyarsadat/Pico-Build-Action'></a>
    |
    <a href='https://github.com/samyarsadat/Pico-Build-Action/actions/workflows/test-action.yml'><img src='https://github.com/samyarsadat/Pico-Build-Action/actions/workflows/test-action.yml/badge.svg'></a>
</p>

<br><br>

----
This is a GitHub Action for building Raspberry Pi Pico (RP2040) C/C++ code.<br>
This is a Docker container action.
<br><br>


## Inputs
| Name                | Description                                                                                                                                                        | Required | Default                      |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ---------------------------- |
| `source_dir`          | _Source code directory. The `CMakeLists.txt` file should be here._                                                                                               | Yes      | `"src"`                      |
| `output_dir`          | _Output directory for build artifacts. This path is relative to the source directory._                                                                           | No       | `"build"`                    |
| `output_ext`          | _A space-separated list of output binary file extensions. There must be a '*' before each extension._                                                            | No       | `"*.uf2 *.elf *.elf.map"` |
| `board_name`          | _Name of the RP2040 board. Please refer to the Pico SDK documentation for a list of supported boards._                                                           | No       | `"pico"`                     |
| `cmake_args`          | _Additional list arguments to pass to CMake._                                                                                                                    | No       | `""`                         |
| `output_ignored_dirs` | _A space-separated list of directories to ignore when copying binary build artifacts. `CMakeFiles`, `pico-sdk`, `pioasm`, and `elf2uf2` are ignored regardless._ | No       | `""`                         |
<br>

## Outputs
| Name              | Description                                                   |
| ----------------- | ------------------------------------------------------------- |
| `output_dir`      | _Relative path to output directory for build artifacts._      |
<br>

## Example usage
```YAML
jobs:
    test_build:
        name: Build example blink program
        runs-on: ubuntu-latest
        permissions:
            contents: read

        steps:
            - name: Checkout
              uses: actions/checkout@v4

            - name: Build Blink Example
              id: build
              uses: ./
              with:
                  source_dir: "test_program"
                  cmake_args: "-DCMAKE_BUILD_TYPE=Debug"

            - name: Upload Build Artifacts
              uses: actions/upload-artifact@v4
              with:
                  name: workspace_artifacts
                  path: ${{steps.build.outputs.output_dir}}
```
<br><br>


## Contact
You can contact me via e-mail.<br>
E-mail: samyarsadat@gigawhat.net
<br><br>
If you think that you have found a bug or issue please report it <a href='https://github.com/samyarsadat/Pico-Build-Action/issues'>here</a>.
<br><br>


## Contributing
Please take a look at <a href='https://github.com/samyarsadat/Pico-Build-Action/blob/main/CONTRIBUTING.md'>CONTRIBUTING.md</a> for contributing.
<br><br>


## Credits
|      Role      |                               Name                               |
|----------------|------------------------------------------------------------------|
| Lead Developer | <a href='https://github.com/samyarsadat'>Samyar Sadat Akhavi</a> |

<br><br>


Copyright © 2024 Samyar Sadat Akhavi.