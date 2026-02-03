# Install OpenIPC on Xiaomi MJSXJ03HL w T31L without disassembly

> [!WARNING]
> Tested only on devices with T31**L** SoC with jxq03p sensor and ZB25VQ128 NOR.

If you not sure about your hardware, [get the dump and inspect logs](#dumping-fw-and-obtain-hw-info) fisrt!

## TL;DR

1. Format a SD card to FAT with MBR table.
2. Replace `YOUR_WIFI_SSID` and `YOUR_WIFI_PASS` in `sdcard/autoconfig.sh`.
3. Copy files from `sdcard/` dir to the SD card.
4. Poweroff the camera.
5. Insert the SD card.
6. Poweron the camera (no need to press\hold the reset button).
7. Wait until flash process finished. The camera should automatically connects to your Wi-Fi.

---

## Dumping FW and obtain HW info

1. Format a SD card to FAT with MBR table.
2. Copy `sdcard/exec.sh` and `sdcard/` to the SD card.
3. Poweroff the camera.
4. Insert the SD card.
5. Poweron the camera (no need to press\hold the reset button).
6. The led indicator should change colors cyclically (blue, red, white).
7. When the fw dumping process completes, the led will ligth up solid red.
8. Poweroff the camera.
9. Remove SD card and insert it to PC.

The FW dump will be located on the SD card in the `dump/` folder.

Example:
```shell
$ tree /media/user/sdcard/dump/
/media/user/sdcard/dump/
├── mtd0_dump.bin # Dump of bootloader
├── mtd1_dump.bin # Dump of FULL spi flash (idk why)
└── mtd.txt
```

Inpect the `exec.log` to know what SoC type, sensor and SPI flash you have.
Example:
```
exec.sh start
SoC model: t31l
SoC raw: ||| 0x10031003 | 0x0031 | 0x00000110 | 0x10 | 0x00000000 | 0x00 | 0x33331111 | 0x3333 | 0xfcacc287 | 0xfcac |
sensor :jxq03p
SPI flash: [    1.418067] the id code = 5e4018, the flash name is ZB25VQ128
Dumping partitions to SDCARD
backup of /dev/mtd0 - done
backup of /dev/mtd1 - done
Error: /sdcard/u-boot.bin not found
```

## How the flash process works in more detail

The method described above relies on a feature(?) of stock bootloader
that allows to read from SD and boot any uImage file that named `factory_t31_ZMC6tiIDQN`.

Custom uImage is used from [thingino project](https://github.com/Andrik45719/MJSXJ03HL/blob/main/SD_thingino/factory_t31_ZMC6tiIDQN).

This uImage can be used to run a custom script [exec.sh](sdcard/exec.sh) from SD card.

The script is used both for dumping the original firmware and for flashing a custom bootloader.

The entire flashing process can be roughly divided into three phases.

### First Phase

1. The Xiaomi U-boot reads and loads the [factory_t31_ZMC6tiIDQN](sdcard/factory_t31_ZMC6tiIDQN)
uImage (kernel + rootfs) from the SD card.

2. After uImage booting, an init script runs, looks for `exec.sh` on the SD card and,
if found, executes it. The LED cycles through colors: red, blue, white.

3. The `exec.sh` script retrieves information about the SoC, sensor, and SPI NOR flash.
It dumps the MTD partitions to the SD card in the `dump/` folder. It then checks if the stock
bootloader is suitable for owerwriting with the custom one.
If it is, `exec.sh` overwrites the stock bootloader with the [u-boot.bin](sdcard/u-boot.bin) from the SD card,
turns blue LED, waits 10 seconds and reboots the camera.
If something went wrong, the red LED will be turn on. In this case you should poweroff the camera, attach
the SD to a PC and inspect `exec.log`.

### Second Phase

1. Atfer reboot the custom U-Boot runs(RED led on) and checks if [boot.scr](sdcard/boot.txt) file
is present on the SD card. If found, the U-boot executes it.

2. When `boot.scr` starts executing, it blinks the red LED 3 times, then loads [uImage.t31](sdcard/uImage.t31)
from the SD card and flashes it to spi nor.
Then it blinks the blue LED 3 times, after which it takes [rootfs.squashfs.t31](sdcard/rootfs.squashfs.t31)
and flashes it too. When the flashing is complete, the white LED lights up and the OpenIPC firmware boots.

### Phase Three

1. After booting, OpenIPC `/lib/mdev/automount.sh` script copy pinmux/gpio settings file
from the SD card ([autoconfig/usr/share/openipc/muxes.sh](sdcard/autoconfig/usr/share/openipc/muxes.sh)).
It also finds [autoconfig.sh](sdcard/autoconfig.sh) on SD and executes it.

2. `autoconfig.sh` script sets the Wi-Fi credentials to the environment variables and reboots the device.

