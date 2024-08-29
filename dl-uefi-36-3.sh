#!/usr/bin/env bash

mkdir uefi-36-3-src && cd uefi-36-3-src

git clone https://github.com/NVIDIA/edk2.git
git -C edk2 checkout -b r36.3.0 r36.3.0
git -C edk2 submodule update --init --recursive

git clone https://github.com/NVIDIA/edk2-non-osi.git
git -C edk2-non-osi checkout -b r36.3.0 r36.3.0
git clone https://github.com/NVIDIA/edk2-platforms.git
git -C edk2-platforms checkout -b r36.3.0 r36.3.0
git -C edk2-platforms submodule update --init --recursive

git clone https://github.com/NVIDIA/edk2-nvidia.git
git -C edk2-nvidia checkout -b r36.3.0 r36.3.0

git clone https://github.com/NVIDIA/edk2-nvidia-non-osi.git
git -C edk2-nvidia-non-osi checkout -b r36.3.0 r36.3.0

git clone https://github.com/NVIDIA/open-gpu-kernel-modules.git
mkdir edk2-nvidia-server-gpu-sdk && mv open-gpu-kernel-modules edk2-nvidia-server-gpu-sdk
git -C edk2-nvidia-server-gpu-sdk/open-gpu-kernel-modules checkout -b 525.78.01 525.78.01

cd ..

