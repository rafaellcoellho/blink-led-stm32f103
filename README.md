# Blink Led STM32f103

A template to start projects with the STM32F1xx family on linux using makefile,
having static analysis and unit tests. The initial example will be the flashing
of a led.

## Prerequisites

First you need to clone this repository on your machine.

```
$ git clone https://github.com/rafaellcoellho/blink-led-stm32f103.git
```

To analyze the code according to the linux kernel code style, the perl
checkpatch script is used. In the scripts folder use dowload.sh to download
directly from /torvalds/linux/scripts. Thanks to riboseinc who write the
[script](https://github.com/riboseinc/checkpatch).

```
$ cd scripts/
$ ./download.sh
```

The static analysis of the code is done through cppcheck. It is open source and
the repository is here in [github](https://github.com/danmar/cppcheck). If you
use ubuntu 14+ or some distro based on it, you can install using:

```
$ sudo apt-get install cppcheck
```

The tests are done with [CppUTest](https://github.com/cpputest/cpputest). You
need to run the setup-cpputest.sh script in the scripts folder. It will
download the test framework inside the project tree.

```
$ cd scripts/
$ ./setup-cpputest.sh
```
Let's use the gcc toolchain for ARM. You must install the compiler, assembler,
linker, and some utilities.

```
$ sudo apt-get install gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi
```

To upload the program to the target processor, the
[stlink](https://github.com/texane/stlink) will be used. Instructions on how to
install are in the following
[article](https://github.com/texane/stlink/blob/master/doc/compiling.md).
Install the following programs:

```
$ sudo apt-get install libusb-1.0 libusb-1.0.0-dev python-usb
```

## Directories

- build - All files generated by the compilation are here.
- cpputest - The cpputest project, downloaded and compiled by
`setup-cpputest.sh`.
- drivers - All libraries goes in there.
- scripts - All scripts written in shell required for the environment.
- src - Where the application src goes, only platform independent code here.
- src_stm32 - Where platform dependent code goes.
- src_tests - Code in c ++ to be tested with the cpputest framework.

## Usage

The make tool tries to run all the scripts needed to build, test, and analyze
the code.

```
make analysis       -> run checkpatch in src and src_stm32
make tests          -> test plataform independent in src
make tests_coverage -> run lcov
make runnable       -> create the .elf .bin and .hex
make clean          -> clean the proj
make flash          -> flash the uC
make erase          -> erase the uC
```

You need to change the TARGET variables in the MakeRunnable.mk and Makefile
files to fit the name of your project.

To add new files to the project, you must include them in the build script
(MakeRunnable.mk file). If you include direct files in the src or src_stm32
folders, go to the C_SOURCES variable and add the file name with the path to
it at the end. Example:

```makefile
C_SOURCES:= \
src_stm32/main.c \
[...]
src/helloWorld.c # <- New file to compile with the proj
```

If you want to create a folder to separate the files from the others, you must
not only change the C_SOURCES, but also SOURCES_DIR and C_INCLUDES with the
path.

Considering that I have placed the helloWorld.c and helloWorld.h files in
src/hello/, we need to make the following changes:

```makefile
SOURCES_DIR:=  \
src_stm32 \
[...]
src/hello
```

```makefile
C_SOURCES:= \
src_stm32/main.c \
[...]
src/hello/helloWorld.c
```

```makefile
C_INCLUDES =  \
-Isrc_stm32 \
[...]
-Isrc/hello
```

Making those changes unnecessary is an improvement for the future.

To upload without having to remove the st-link v2 from the USB port, you only
need to press the reset button on the board and erase all memory:

```
Press reset button

$ make erase

st-flash erase
st-flash 1.4.0
2018-01-12T14:00:53 INFO src/common.c: Loading device parameters....
2018-01-12T14:00:53 INFO src/common.c: Device connected is: F1 Medium-density
device, id 0x20036410
2018-01-12T14:00:53 INFO src/common.c: SRAM size: 0x5000 bytes (20 KiB), Flash:
 0x20000 bytes (128 KiB) in pages of 1024 bytes

$ make flash

st-flash write blink_led.bin 0x8000000
st-flash 1.4.0
2018-01-12T14:00:58 INFO src/common.c: Loading device parameters....
2018-01-12T14:00:58 INFO src/common.c: Device connected is: F1 Medium-density device, id 0x20036410
2018-01-12T14:00:58 INFO src/common.c: SRAM size: 0x5000 bytes (20 KiB), Flash: 0x20000 bytes (128 KiB) in pages of 1024 bytes
2018-01-12T14:00:58 INFO src/common.c: Attempting to write 4804 (0x12c4) bytes to stm32 address: 134217728 (0x8000000)
Flash page at addr: 0x08001000 erased
2018-01-12T14:00:58 INFO src/common.c: Finished erasing 5 pages of 1024 (0x400) bytes
2018-01-12T14:00:58 INFO src/common.c: Starting Flash write for VL/F0/F3/F1_XL core id
2018-01-12T14:00:58 INFO src/flash_loader.c: Successfully loaded flash loader in sram
  5/5 pages written
2018-01-12T14:00:59 INFO src/common.c: Starting verification of write complete
2018-01-12T14:00:59 INFO src/common.c: Flash written and verified! jolly good!
```


## Authors

* **Rafael Coelho** - [rafaellcoellho](https://github.com/rafaellcoellho)
