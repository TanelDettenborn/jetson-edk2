#!/usr/bin/env bash
set -xeu -o pipefail
cd uefi-36-3-src  
export WORKSPACE="$PWD"
export PYTHONPATH="$PWD"/edk2-nvidia/Silicon/NVIDIA/scripts/..
#export CROSS_COMPILER_PREFIX="$(dirname $(command -v aarch64-linux-gnu-gcc))/aarch64-linux-gnu-"
stuart_update -c "$PWD"/edk2-nvidia/Platform/NVIDIA/Jetson/PlatformBuild.py
python edk2/BaseTools/Edk2ToolsBuild.py -t GCC5
stuart_build -c "$PWD"/edk2-nvidia/Platform/NVIDIA/Jetson/PlatformBuild.py --verbose --target DEBUG
