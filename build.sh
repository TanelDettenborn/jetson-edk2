#!/usr/bin/env bash
set -xeu -o pipefail

cd uefi-36-3-src
export WORKSPACE="$PWD"
export PYTHONPATH="$PWD"/edk2-nvidia/Silicon/NVIDIA/scripts/..

#FIXME/NIXIFY: Collect build tools into same directory
rm -rf bin && mkdir bin && chmod +x bin
ln -s $(command -v aarch64-linux-gnu-gcc) bin/aarch64-linux-gnu-gcc
ln -s $(command -v aarch64-linux-gnu-gcc-ar) bin/aarch64-linux-gnu-gcc-ar
ln -s $(command -v aarch64-linux-gnu-ar) bin/aarch64-linux-gnu-ar
ln -s $(command -v aarch64-linux-gnu-cpp) bin/aarch64-linux-gnu-cpp
ln -s $(command -v aarch64-linux-gnu-objcopy) bin/aarch64-linux-gnu-objcopy
export CROSS_COMPILER_PREFIX="$PWD"/bin/aarch64-linux-gnu-

stuart_update -c "$PWD"/edk2-nvidia/Platform/NVIDIA/Jetson/PlatformBuild.py
python edk2/BaseTools/Edk2ToolsBuild.py -t GCC

# FIXME/NIXIFY: Use iasl-tool from pkgs
mkdir -p edk2-nvidia/Platform/NVIDIA/edk2-acpica-iasl_extdep/Linux-x86
rm -f edk2-nvidia/Platform/NVIDIA/edk2-acpica-iasl_extdep/Linux-x86/iasl
ln -s $(command -v iasl) edk2-nvidia/Platform/NVIDIA/edk2-acpica-iasl_extdep/Linux-x86/iasl

stuart_build -c "$PWD"/edk2-nvidia/Platform/NVIDIA/Jetson/PlatformBuild.py --verbose --target DEBUG
