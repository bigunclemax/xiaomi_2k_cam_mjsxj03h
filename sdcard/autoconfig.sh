#!/bin/sh

fw_setenv wlanssid YOUR_WIFI_SSID
fw_setenv wlanpass YOUR_WIFI_PASS

SCRIPT_PATH=$(dirname $(realpath "$0"))
mv $SCRIPT_PATH/boot.scr $SCRIPT_PATH/_boot.scr

reboot

