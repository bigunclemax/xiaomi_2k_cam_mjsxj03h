# Xiaomi Smart Camera MJSXJ03HL 2K

# Hardware
[Photos](./pics)  

**Mainboard version**  
`2025-03-13 KPJ_MAINBOARD_V1.2`

**SoC**  
Ingenic T31 4307022910301801-L

**SPI NOR FLASH 128Mbit (16MB)**  
ba2507 25vq128dsjg p44702

**Audio amplifer**  
HT6872

**DC-DC ?**  
6208

**WIFI**  
? rtl8189ftv


# Stock software

[Dumps of original firmware](./original_dumps/)  
[Logs](./logs/)  

## Xiaomi U-boot
### Version
```
U-Boot SPL 2013.07-g8581847-dirty (Aug 09 2021 - 18:07:12)
U-Boot 2013.07-g8581847-dirty (Aug 09 2021 - 18:07:12
```

### Envs
```
bootargs=console=ttyS1,115200n8 mem=42M@0x0 rmem=22M@0x2A00000 init=/linuxrc rootfstype=squashfs root=/dev/mtdblock2 rw mtdparts=jz_sfc:256K(boot),1984K(kernel),3904K(rootfs),3904K(app),1984K(kback),3904K(aback),384K(cfg),64K(para)
bootcmd=mw 0xb0011134 0x300 1;sdstart;sdupdate;sf probe;sf read 0x80600000 0x40000 0x1F0000; bootm 0x80600000
bootdelay=0
baudrate=115200
loads_echo=1
ethaddr=00:d0:d0:00:95:27
ipaddr=193.169.4.81
serverip=193.169.4.2
gatewayip=193.169.4.1
netmask=255.255.255.0
```

### SD pins config

bootcmd contains the following line:
```
mw 0xb0011134 0x300 1
```
> [!WARNING] without it the sdmmc0 doesn't work correctly

### More GPIO info

During normal boot, U-boot GPIO configuration in `misc_init_r()` prints the following logs
that helps to understand pin assignment:

```
misc_init_r before change the wifi_enable_gpio
gpio_request lable = wifi_enable_gpio gpio = 58
misc_init_r after gpio_request the wifi_enable_gpio ret is 58
misc_init_r after change the wifi_enable_gpio ret is 0
misc_init_r before change the yellow_gpio
gpio_request lable = yellow_gpio gpio = 39
misc_init_r after gpio_request the yellow_gpio ret is 39
misc_init_r after change the yellow_gpio ret is 1
misc_init_r before change the blue_gpio
gpio_request lable = blue_gpio gpio = 38
misc_init_r after gpio_request the blue_gpio ret is 38
misc_init_r after change the blue_gpio ret is 0
gpio_request lable = night_gpio gpio = 60
misc_init_r after gpio_request the night_gpio ret is 60
misc_init_r after change the night_gpio ret is 0
gpio_request lable = SPK_able_gpio gpio = 63
misc_init_r after gpio_request the SPK_able_gpio ret is 63
misc_init_r after change the SPK_able_gpio ret is 0
gpio_request lable = TF_en_gpio gpio = 47
misc_init_r after gpio_request the TF_en_gpio ret is 47
misc_init_r after change the TF_en_gpio ret is 0
gpio_request lable = TF_cd_gpio gpio = 48
misc_init_r after gpio_request the TF_cd_gpio ret is 48
misc_init_r after change the TF_cd_gpio ret is 0
gpio_request lable = SD_able_gpio gpio = 54
misc_init_r after change the SD_able_gpio ret is 0
misc_init_r before change the wifi_enable_gpio
gpio_request lable = wifi_enable_gpio gpio = 58
misc_init_r after gpio_request the wifi_enable_gpio ret is 58
misc_init_r after change the wifi_enable_gpio ret is 1
Hit any key to stop autoboot:  0 
Card did not respond to voltage select!
SD card is not insert
gpio_request lable = sdupgrade gpio = 51
```

| NAME			| NUMBER	| DIRECTION	| DESCRIPTION
|-----------------------|---------------|---------------|-----------------------------------------|
|`blue_gpio`		| 38		| out		| 0 - off, 1 - on, boot seq: ?->0
|`yellow_gpio`		| 39      	| out		| 0 - off, 1 - on, boot seq: ?->1
|`TF_en_gpio`		| 47		|		| ?->0
|`TF_cd_gpio`		| 48		|		| ?->0
|`sdupgrade`		| 51		| in		| 0 - btn pressed, 1 - btn released
|`SD_able_gpio`		| 54		| out		| 0 - sd works, 1 - sd error, boot seq: ?->0
|`wifi_enable_gpio`	| 58		| out		| boot seq: ?->0->1
|`night_gpio`		| 60		|?		|
|`SPK_able_gpio`	| 63		|		| ?->0


### Recovery

When the reset button is held down before power is applied, additional lines appear in U-boot:

```
Card did not respond to voltage select!
SD card is not insert
sdupdate - auto upgrade file!

Usage:
sdupdate  
the manufacturer 5e
SF: Detected ZB25VQ128
```

### sdupdate & sdupgrade

Some interesting file names:

`factory_t31_ZMC6tiIDQN`
`demo_hlc7_boot.bin`
`demo_hlc7.bin`


## Xiaomi Kernel

### Version
```
Linux version 3.10.14__isvp_swan_1.0__ (xuxuequan@ubuntu) (gcc version 4.7.2 (Ingenic r2.3.3 2016.12) ) #0 PREEMPT Mon Jul 12 02:36:24 CST 2021
```

### Cmdline

```
Kernel command line: console=ttyS1,115200n8 mem=42M@0x0 rmem=22M@0x2A00000 init=/linuxrc rootfstype=squashfs root=/dev/mtdblock2 rw mtdparts=jz_sfc:256K(boot),1984K(kernel),3904K(rootfs),3904K(app),1984K(kback),3904K(aback),384K(cfg),64K(para)
```

### MTD Partitions

```
[    0.409399] Creating 8 MTD partitions on "jz_sfc":
[    0.414392] 0x000000000000-0x000000040000 : "boot"
[    0.419860] 0x000000040000-0x000000230000 : "kernel"
[    0.425518] 0x000000230000-0x000000600000 : "rootfs"
[    0.431106] 0x000000600000-0x0000009d0000 : "app"
[    0.436494] 0x0000009d0000-0x000000bc0000 : "kback"
[    0.441984] 0x000000bc0000-0x000000f90000 : "aback"
[    0.447541] 0x000000f90000-0x000000ff0000 : "cfg"
[    0.452856] 0x000000ff0000-0x000001000000 : "para"
```

### rtl8189ftv
```
[    2.351081] RTL871X: module init start
[    2.356739] RTL871X: rtl8189ftv v4.3.24.7_21113.20170208.nova.1.02
[    2.363131] RTL871X: build time: Aug 14 2020 13:46:20
[    2.384657] RTL871X: module init ret=0
[    2.473573] RTL871X: ++++++++rtw_drv_init: vendor=0x024c device=0xf179 class=0x07
[    2.529462] RTL871X: HW EFUSE
[    2.532553] RTL871X: hal_com_config_channel_plan chplan:0x20
[    2.713679] RTL871X: rtw_regsty_chk_target_tx_power_valid return _FALSE for band:0, path:0, rs:0, t:-1
[    2.744518] RTL871X: rtw_ndev_init(wlan0) if1 mac_addr=c8:5c:cc:97:a7:70
```

### Login

User: `root`  
Password: `ismart12`  

Info from [here](https://radiofisik.ru/2024/12/26/micam/)

### SDMMC controllers

MMC0 - sd card  
MMC1 - wifi  

It seems that card detect does not work property.
A handle via sysfs is used instead:

`echo "INSERT" > /sys/devices/platform/jzmmc_v1.2.0/present`  
`echo "INSERT" > /sys/devices/platform/jzmmc_v1.2.1/present`  
`echo "REMOVE" > /sys/devices/platform/jzmmc_v1.2.1/present`  


## Pinmux\GPIO config

Dump of pinmux and gpio registers with `ipctool`
```
[root@Ingenic-uc1_1:~]# /tmp/ipctool-mips32 reginfo
muxctrl_reg0 0x10010000 0x11477fc0 PAPIN
muxctrl_reg1 0x10010010 0 [PAINT]
muxctrl_reg2 0x10010014 0 [PAINTS]
muxctrl_reg3 0x10010018 0 [PAINTC]
muxctrl_reg4 0x10010020 0x6444fc0 PAMSK
muxctrl_reg5 0x10010024 0 [PAMSKS]
muxctrl_reg6 0x10010028 0 [PAMSKC]
muxctrl_reg7 0x10010030 0x6434bc0 PAPAT1
muxctrl_reg8 0x10010034 0 [PAPAT1S]
muxctrl_reg9 0x10010038 0 [PAPAT1C]
muxctrl_reg10 0x10010040 0x1f84b400 PAPAT0
muxctrl_reg11 0x10010044 0 [PAPAT0S]
muxctrl_reg12 0x10010048 0 [PAPAT0C]
muxctrl_reg13 0x10010050 0 [PAFLG]
muxctrl_reg14 0x10010058 0 [PAFLGC]
muxctrl_reg15 0x10010070 0 [PAGFCFG0]
muxctrl_reg16 0x10010074 0 [PAGFCFG0S]
muxctrl_reg17 0x10010078 0 [PAGFCFG0C]
muxctrl_reg18 0x10010080 0 [PAGFCFG1]
muxctrl_reg19 0x10010084 0 [PAGFCFG1S]
muxctrl_reg20 0x10010088 0 [PAGFCFG1C]
muxctrl_reg21 0x10010090 0 [PAGFCFG2]
muxctrl_reg22 0x10010094 0 [PAGFCFG2S]
muxctrl_reg23 0x10010098 0 [PAGFCFG2C]
muxctrl_reg24 0x100100a0 0 [PAGFCFG3]
muxctrl_reg25 0x100100a4 0 [PAGFCFG3S]
muxctrl_reg26 0x100100a8 0 [PAGFCFG3C]
muxctrl_reg27 0x10010110 0x473800 PAPUEN
muxctrl_reg28 0x10010114 0 [PAPUENS]
muxctrl_reg29 0x10010118 0 [PAPUENC]
muxctrl_reg30 0x10010120 0 [PAPDEN]
muxctrl_reg31 0x10010124 0 [PAPDENS]
muxctrl_reg32 0x10010128 0 [PAPDENC]
muxctrl_reg33 0x10010130 0x2aaaa000 PAPDRVL
muxctrl_reg34 0x10010134 0 [PAPDRVLS]
muxctrl_reg35 0x10010138 0 [PAPDRVLC]
muxctrl_reg36 0x10010140 0x169602a PAPDRVH
muxctrl_reg37 0x10010144 0 [PAPDRVHS]
muxctrl_reg38 0x10010148 0 [PAPDRVHC]
muxctrl_reg39 0x10010150 0x8000 PAPSLW
muxctrl_reg40 0x10010154 0 [PAPSLWS]
muxctrl_reg41 0x10010158 0 [PAPSLWC]
muxctrl_reg42 0x10010160 0x400000 PAPSMT
muxctrl_reg43 0x10010164 0 [PAPSMTS]
muxctrl_reg44 0x10010168 0 [PAPSMTC]
muxctrl_reg45 0x10011000 0x65086ebf PBPIN
muxctrl_reg46 0x10011010 0x8000 PBINT
muxctrl_reg47 0x10011014 0 [PBINTS]
muxctrl_reg48 0x10011018 0 [PBINTC]
muxctrl_reg49 0x10011020 0xfe7f00c0 PBMSK
muxctrl_reg50 0x10011024 0 [PBMSKS]
muxctrl_reg51 0x10011028 0 [PBMSKC]
muxctrl_reg52 0x10011030 0x2a390000 PBPAT1
muxctrl_reg53 0x10011034 0 [PBPAT1S]
muxctrl_reg54 0x10011038 0 [PBPAT1C]
muxctrl_reg55 0x10011040 0x4400ef80 PBPAT0
muxctrl_reg56 0x10011044 0 [PBPAT0S]
muxctrl_reg57 0x10011048 0 [PBPAT0C]
muxctrl_reg58 0x10011050 0 [PBFLG]
muxctrl_reg59 0x10011058 0 [PBFLGC]
muxctrl_reg60 0x10011070 0 [PBGFCFG0]
muxctrl_reg61 0x10011074 0 [PBGFCFG0S]
muxctrl_reg62 0x10011078 0 [PBGFCFG0C]
muxctrl_reg63 0x10011080 0 [PBGFCFG1]
muxctrl_reg64 0x10011084 0 [PBGFCFG1S]
muxctrl_reg65 0x10011088 0 [PBGFCFG1C]
muxctrl_reg66 0x10011090 0 [PBGFCFG2]
muxctrl_reg67 0x10011094 0 [PBGFCFG2S]
muxctrl_reg68 0x10011098 0 [PBGFCFG2C]
muxctrl_reg69 0x100110a0 0 [PBGFCFG3]
muxctrl_reg70 0x100110a4 0 [PBGFCFG3S]
muxctrl_reg71 0x100110a8 0 [PBGFCFG3C]
muxctrl_reg72 0x10011110 0x66094800 PBPUEN
muxctrl_reg73 0x10011114 0 [PBPUENS]
muxctrl_reg74 0x10011118 0 [PBPUENC]
muxctrl_reg75 0x10011120 0x98060000 PBPDEN
muxctrl_reg76 0x10011124 0 [PBPDENS]
muxctrl_reg77 0x10011128 0 [PBPDENC]
muxctrl_reg78 0x10011130 0x20100 PBPDRVL
muxctrl_reg79 0x10011134 0 [PBDRVLS]
muxctrl_reg80 0x10011138 0 [PBDRVLC]
muxctrl_reg81 0x10011140 0 [PBDRVH]
muxctrl_reg82 0x10011144 0 [PBDRVHS]
muxctrl_reg83 0x10011148 0 [PBDRVHC]
muxctrl_reg84 0x10011150 0 [PBSLW]
muxctrl_reg85 0x10011154 0 [PBSLWS]
muxctrl_reg86 0x10011158 0 [PBSLWC]
muxctrl_reg87 0x10011160 0x60000000 PBSMT
muxctrl_reg88 0x10011164 0 [PBSMTS]
muxctrl_reg89 0x10011168 0 [PBSMTC]
muxctrl_reg90 0x10012000 0x4309 PCPIN
muxctrl_reg91 0x10012010 0x1 PCINT
muxctrl_reg92 0x10012014 0 [PCINTS]
muxctrl_reg93 0x10012018 0 [PCINTC]
muxctrl_reg94 0x10012020 0x7fffbfe PCMSK
muxctrl_reg95 0x10012024 0 [PCMSKS]
muxctrl_reg96 0x10012028 0 [PCMSKC]
muxctrl_reg97 0x10012030 0x7fffbfe PCPAT1
muxctrl_reg98 0x10012034 0 [PCPAT1S]
muxctrl_reg99 0x10012038 0 [PCPAT1C]
muxctrl_reg100 0x10012040 0 [PCPAT0]
muxctrl_reg101 0x10012044 0 [PCPAT0S]
muxctrl_reg102 0x10012048 0 [PCPAT0C]
muxctrl_reg103 0x10012050 0 [PCFLG]
muxctrl_reg104 0x10012058 0 [PCFLGC]
muxctrl_reg105 0x10012070 0 [PCGFCFG0]
muxctrl_reg106 0x10012074 0 [PCGFCFG0S]
muxctrl_reg107 0x10012078 0 [PCGFCFG0C]
muxctrl_reg108 0x10012080 0 [PCGFCFG1]
muxctrl_reg109 0x10012084 0 [PCGFCFG1S]
muxctrl_reg110 0x10012088 0 [PCGFCFG1C]
muxctrl_reg111 0x10012090 0 [PCGFCFG2]
muxctrl_reg112 0x10012094 0 [PCGFCFG2S]
muxctrl_reg113 0x10012098 0 [PCGFCFG2C]
muxctrl_reg114 0x100120a0 0 [PCGFCFG3]
muxctrl_reg115 0x100120a4 0 [PCGFCFG3S]
muxctrl_reg116 0x100120a8 0 [PCGFCFG3C]
muxctrl_reg117 0x10012110 0x4309 PCPUEN
muxctrl_reg118 0x10012114 0 [PCPUENS]
muxctrl_reg119 0x10012118 0 [PCPUENC]
muxctrl_reg120 0x10012120 0x60002 PCPDEN
muxctrl_reg121 0x10012124 0 [PCPDENS]
muxctrl_reg122 0x10012128 0 [PCPDENC]
muxctrl_reg123 0x10012130 0 [PCDRVL]
muxctrl_reg124 0x10012134 0 [PCDRVLS]
muxctrl_reg125 0x10012138 0 [PCDRVLC]
muxctrl_reg126 0x10012140 0 [PCDRVH]
muxctrl_reg127 0x10012144 0 [PCDRVHS]
muxctrl_reg128 0x10012148 0 [PCDRVHC]
muxctrl_reg129 0x10012150 0 [PCSLW]
muxctrl_reg130 0x10012154 0 [PCSLWS]
muxctrl_reg131 0x10012158 0 [PCSLWC]
muxctrl_reg132 0x10012160 0x1e0000 PCSMT
muxctrl_reg133 0x10012164 0 [PCSMTS]
muxctrl_reg134 0x10012168 0 [PCSMTC]
muxctrl_reg135 0x10017014 0 [PZINTS]
muxctrl_reg136 0x10017018 0 [PZINTC]
muxctrl_reg137 0x10017024 0 [PZMSKS]
muxctrl_reg138 0x10017028 0 [PZMSKC]
muxctrl_reg139 0x10017034 0 [PZPAT1S]
muxctrl_reg140 0x10017038 0 [PZPAT1C]
muxctrl_reg141 0x10017044 0 [PZPAT0S]
muxctrl_reg142 0x10017048 0 [PZPAT0C]
muxctrl_reg143 0x100170f0 0 [PZGID2LD]
```

Exported GPIO:
```
--w-------    1 root     root          4096 Jan  1 08:00 export
lrwxrwxrwx    1 root     root             0 Jan  1 08:00 gpio10 -> ../../devices/virtual/gpio/gpio10
lrwxrwxrwx    1 root     root             0 Jan  1 08:00 gpio38 -> ../../devices/virtual/gpio/gpio38
lrwxrwxrwx    1 root     root             0 Jan  1 08:00 gpio39 -> ../../devices/virtual/gpio/gpio39
lrwxrwxrwx    1 root     root             0 Jan  1 08:00 gpio48 -> ../../devices/virtual/gpio/gpio48
lrwxrwxrwx    1 root     root             0 Jan  1 08:00 gpio49 -> ../../devices/virtual/gpio/gpio49
lrwxrwxrwx    1 root     root             0 Jan  1 08:00 gpio50 -> ../../devices/virtual/gpio/gpio50
lrwxrwxrwx    1 root     root             0 Jan  1 08:00 gpio51 -> ../../devices/virtual/gpio/gpio51
lrwxrwxrwx    1 root     root             0 Jan  1 08:00 gpio54 -> ../../devices/virtual/gpio/gpio54
lrwxrwxrwx    1 root     root             0 Jan  1 08:00 gpio60 -> ../../devices/virtual/gpio/gpio60
lrwxrwxrwx    1 root     root             0 Jan  1 08:00 gpiochip0 -> ../../devices/virtual/gpio/gpiochip0
lrwxrwxrwx    1 root     root             0 Jan  1 08:00 gpiochip32 -> ../../devices/virtual/gpio/gpiochip32
lrwxrwxrwx    1 root     root             0 Jan  1 08:00 gpiochip64 -> ../../devices/virtual/gpio/gpiochip64
```

### Some GPIO related setup from `bin/init_app.sh`

```shell
#设置PB04的驱动能力(4mA)
#Configure the drive capability of PB04 (4mA).
devmem 0x10011138 32 0xfff
devmem 0x10011134 32 0x100

#设置PA15的2mA驱动能力
#Configure PA15 to have a 2mA drive capability.
devmem 0x10010138 32 0xc0000000
devmem 0x10010134 32 0x00000000

#wifi mmc1中的PB10默认是下拉的状态，需要将它设置成高阻态	
#In the WiFi MMC1, PB10 is in a pulled-down state by default; it needs to be set to a high-impedance state.
devmem 0x10011128 32 0x400	
#wifi mmc1 clk驱动能力改到8mA
#Change the WiFi MMC1 CLK driver capability to 8mA
devmem 0x10011134 32 0x20000
```

`#xiaomisecuritychip` - wtf?
```shell
#小米安全芯片
echo 10 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio10/direction
```


## "Exploit" for stock FW 
Xiaomi U-boot, during the boot process, checks for the presence of a uImage
file named `factory_t31_ZMC6tiIDQN` on the SD card, and if finds this image,
then loads it.

This method is not my invention; for example, it is used for installation of
[Thingino project](https://github.com/Andrik45719/MJSXJ03HL/blob/main/SD_thingino/factory_t31_ZMC6tiIDQN).

I decompressed `SD_thingino/factory_t31_ZMC6tiIDQN` to see what's inside.

The init script of this factory contains following lines:
```shell
echo "sh /sdcard/exec.sh"
sh /sdcard/exec.sh
```

So, we can place our own `exec.sh` on the SD card and init will execute it.

Thingino factory `factory_t31_ZMC6tiIDQN` parititons layout:
```
[    1.441485] 0x000000000000-0x000000040000 : "boot"
[    1.447762] 0x000000000000-0x000001000000 : "all"
```

Thingino facroty  `factory_t31_ZMC6tiIDQN` cmdline:
`console=ttyS1,115200n8 mem=42M@0x0 rmem=22M@0x2A00000 init=/init mtdparts=jz_sfc:256K(boot),16384k@0(all)`

This partitioning scheme allows us to read\write the entire flash memory with two files.


## OpenIPC U-boot

```shell
git clone https://github.com/Dafang-Hacks/mips-gcc472-glibc216-64bit.git
git clone https://github.com/bigunclemax/u-boot-ingenic
export PATH="$PATH:$(realpath ./mips-gcc472-glibc216-64bit/bin)"
wget https://github.com/bigunclemax/xiaomi_2k_cam_mjsxj03h/raw/refs/heads/master/original_dumps/mjsxj03hl_SN_31389_03381321/mtd0_dump.bin
cd u-boot-ingenic
make distclean
make CROSS_COMPILE=mips-linux-gnu- isvp_t31_sfcnor_lite
./concat_uboot.sh ../mtd0_dump.bin u-boot.bin ../u-boot.bin
```

# Flash SPI NOR with ch341a
## Build microsander
```
git clone https://github.com/OpenIPC/microsnander.git
cd microsnander/src && make
```


## Flash boot part (0x0 - 0x40000)
```
sudo ./microsnander -e -a 0 -l 262144
sudo ./microsnander -v -a 0 -w mtd0_dump.bin
```


## Flash whole nor
```
sudo ./microsnander -e
sudo ./microsnander -v -w mtd1_dump.bin
```

