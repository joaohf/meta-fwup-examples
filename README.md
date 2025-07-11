# fwup examples meta layer

This is a Yocto meta layer with examples for building [fwup, a configurable embedded Linux firmware update creator and runner](https://github.com/fwup-home/fwup)
images for Yocto projects.

It also provides additional qemu machines in additional to the default [QEMU machines provided by the Yocto Project](https://git.yoctoproject.org/poky/tree/README.qemu.md).
The main idea is to add machines based on QEMU with additional support like using u-boot/grub as bootloader and
ready to use with fwup.

ARM based:

 * qemuarm-uboot, qemuarm machine configured to boot from u-boot
 * qemuarm64-uboot, qemuarm64 machine configured to boot from u-boot

x86-64 based:

 * qemux86-64-grub, qemux86-64 machine with grub and EFI enabled

## Dependencies:

This layer depends on: 

* URI: https://github.com/fwup-home/meta-fwup layers: meta-fwup

## Usage

For `conf/bblayers.conf` you have to add

```text
BBLAYERS ?= " \
   ...
  path_to_source/sources/meta-fwup-examples \
  "
```

Or, using `bitbake-layers`:

```
bitbake-layers add-layer meta-fwup-examples
```

This layer has configurations for QEMU with uboot and raspberry pi based machines.

One additional layer will be necessary depending on your use case:

 * [meta-raspberry](https://github.com/agherzan/meta-raspberrypi)

## Enabling fwup image class

In order to generate fwup images, it's necessary to add the following configuration to `conf/local.conf` file:

```
# fwup support
IMAGE_CLASSES += "image_types_fwup"
IMAGE_FSTYPES = "fwup fwup.qcow2"
```

## Deployed artifacts files

It's important to know that when configuring the variable `IMAGE_FSTYPES` with
the values `"fwup fwup.qcow2"` the following image files will be created:

* `core-image-minimal-qemuarm-uboot.rootfs-20241219203235.fwup`, an image suitable to burn it into a media, like sdcard
* `core-image-minimal-qemuarm-uboot.rootfs-20241219203235.fwup.qcow2`, an image suitable for running withe QEMU (runqemu)

There is an additional file created by meta-fwup layer:

* `core-image-minimal-qemuarm-uboot.rootfs-20241219203235.fw`, this file is the firmware file created by [fwup command](https://github.com/fwup-home/fwup).

## Use cases

Basic configuration valid for all:

It's necessary to include the layer meta-qemu-bsp in `conf/bblayers.conf` configuration file:

```text
BBLAYERS ?= " \
   ...
  path_to_source/sources/meta-qemu-bsp \
  "
```

To active the fwup generation, add the following configuration in `conf/local.conf` file:

```
# fwup support
IMAGE_CLASSES += "image_types_fwup"
IMAGE_FSTYPES = "fwup fwup.qcow2"
```

### qemuarm machine with u-boot bootloader

This example builds a Yocto image with u-boot as bootloader and prepared to work with QEMU emulator.

Add to `conf/local.conf` the MACHINE to use:

```
MACHINE = "qemuarm-uboot"
```

Instead `MACHINE = "qemuarm-uboot"`, it's also possible to use `qemuarm64-uboot`.

The `qemuarm-uboot` machine is provided by [meta-qemu-bsp layer](https://www.github.com/meta-erlang/meta-qemu-bsp) layer. 
That layer is necessary to run this example as it enables booting u-boot from qemu.

This example uses the fwup config file from `fwup/core-image-minimal.qemuarm-uboot.fwup` which
describes the partition layout, fwup tasks and variables.

This layer also provides an [uboot environment script](recipes-bsp/u-boot/files/qemuarm/uboot.txt.env) integrated
with core-image-minimal.qemuarm-uboot.fwup variables.

Running the following bitbake command:

```
bitbake core-image-minimal
```

Creates the .fwup.qcow2 image suitable for use with `runqemu` command.

```
tree build/tmp/deploy/images/qemuarm-uboot/
build/tmp/deploy/images/qemuarm-uboot/
├── core-image-minimal-qemuarm-uboot.rootfs-20241219203235.fw
├── core-image-minimal-qemuarm-uboot.rootfs-20241219203235.fwup
├── core-image-minimal-qemuarm-uboot.rootfs-20241219203235.fwup.qcow2
```

So, calling runqemu in order to start the image inside qemu:

```
runqemu core-image-minimal nographic serialstdio slirp wic.qcow2
```

## Patches

Please submit any patches against the meta-fwup-examples to the github issue tracker.

Maintainer: João Henrique Ferreira de Freitas `<joaohf@gmail.com>`

## References

The machines qemuarm-uboot and qemuarm64-uboot were based on [meta-qemuarm-uboot](https://github.com/ejaaskel/meta-qemuarm-uboot/).
The blog post called [Yocto Emulation: Setting Up QEMU with U-Boot](https://ejaaskel.dev/yocto-emulation-setting-up-qemu-with-u-boot/)
tells about how would it be possible to boot qemu with u-boot.
