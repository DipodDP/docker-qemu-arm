#!/bin/bash

sudo dnf install -y qemu-system-x86-core edk2-ovmf expect

mkdir -p alpine
cd alpine

# URL / BRANCH might be overwritten here
. ../config.env

cp ../answerfile .
cp ../ssh2qemu.sh .
cp ../startqemu.sh .
cp ../installqemu.expect .
chmod +x ./ssh2qemu.sh
chmod +x ./startqemu.sh
sed -i "s:\$PREFIX/share/qemu/edk2-x86_64-code.fd:/usr/share/edk2/ovmf/OVMF_CODE.fd:g" ./startqemu.sh
sed -i "s:\$env(PREFIX)/share/qemu/edk2-x86_64-code.fd:/usr/share/edk2/ovmf/OVMF_CODE.fd:g" ./installqemu.expect
expect -f ./installqemu.expect
