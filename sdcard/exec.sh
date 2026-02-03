#/bin/sh

# set -x

exec 1> /tmp/exec.log 2>&1

log() {
        echo "$*"
        echo "$*" > /dev/kmsg
}

log "exec.sh start"

log "SoC model: $(/sbin/soc -m)"
log "SoC raw: $(/sbin/soc -w)"
log "$(cat /proc/jz/sinfo/info)"
log "SPI flash: $(dmesg | grep 'flash name is')"

dmesg > /tmp/dmesg.log

# Uncomment the line below if you need a shell
#exec /bin/ash </dev/ttyS1 >/dev/ttyS1 2>&1

DUMP_DIR="/sdcard/dump/"

log "Dumping partitions to SDCARD"

mkdir -p "$DUMP_DIR"

cat /proc/mtd > "$DUMP_DIR/mtd.txt"

for MTD in /dev/mtd[0-9] /dev/mtd[0-9][0-9] ; do

	[ ! -c "$MTD" ] && continue

	if ! dd if="$MTD" of="$DUMP_DIR/${MTD##*/}_dump.bin" bs=4096 conv=fsync 2>/dev/null; then
		log "Error: Failed to backup $MTD"
		EXEC_STATE="ERR"
	else
		log "backup of $MTD - done"
	fi
done

cp /tmp/* /sdcard/
sync

ORIG_MTD0_SHA256=3fce2aa777f15f5ce9e0add5078526a1d5021ff4fd6c3480443eb3c72569b797
if [ "$EXEC_STATE" != "ERR" ]; then
	DUMP_MTD0_SHA256=$(sha256sum "$DUMP_DIR/mtd0_dump.bin" | awk '{print $1}')

	if [ "$ORIG_MTD0_SHA256" != "$DUMP_MTD0_SHA256" ]; then
		log "Error: not tested with current bootloader"
		EXEC_STATE="ERR"
	fi
fi

UBOOT_BIN="/sdcard/u-boot.bin"
if [ "$EXEC_STATE" != "ERR" ]; then
	if [ ! -f $UBOOT_BIN ]; then
		log "Error: $UBOOT_BIN not found"
		EXEC_STATE="ERR"
	else
		log "Start flashing U-boot"
		flashcp -v "$UBOOT_BIN" /dev/mtd0
		log "Flash U-boot ret: $?"
	fi
fi

cp /tmp/* /sdcard/
sync
umount /sdcard
log "SDCARD unmounted"

led_pid="$(ps | grep "led.sh" | grep -v grep | awk '{print $1}')"
kill $led_pid


if [ "$EXEC_STATE" != "ERR" ]; then
	# Turn on blue led
	echo 0 > /sys/class/gpio/gpio39/value
	echo 1 > /sys/class/gpio/gpio38/value

	sleep 10

	log "exec.sh done"
	log "rebooting..."

	echo wdt > /proc/jz/reset/reset
else
	# Turn on red led
	echo 1 > /sys/class/gpio/gpio39/value
	echo 0 > /sys/class/gpio/gpio38/value

	exec /bin/ash </dev/ttyS1 >/dev/ttyS1 2>&1
fi
