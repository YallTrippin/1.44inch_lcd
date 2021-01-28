sudo chown pi /opt
mkdir /opt/dev
sudo apt-get install git bc libncurses5-dev
git clone --depth=1 https://github.com/raspberrypi/linux /opt/dev/linux
cd /opt/dev/linux
KERNEL=kernel
make bcmrpi_defconfig
make -j4 zImage modules dtbs
sudo make modules_install
sudo cp arch/arm/boot/dts/*.dtb /boot/
sudo cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/
sudo cp arch/arm/boot/zImage /boot/$KERNEL.img
# sudo reboot now

# install touchscreen
cd /opt/dev/linux/drivers/input/touchscreen
wget https://www.waveshare.com/w/upload/c/cd/WS_7inch_C.c
sudo nano Makefile
# add "obj-$(CONFIG_USB_WaveShare_WS_7inch_C)  += WS_7inch_C.o"

sudo nano Kconfig
# add the 5 lines below without "#"
#
# config USB_WaveShare_WS_7inch_C
# tristate "WaveShare_WS_7inch_C"
# depends on USB && INPUT
# ---help---
#        WaveShare_WS_7inch_C

# change the Waveshare_Rotate value on WS_7inch_C.c
# 
# Waveshare_Rotate=0, #0 degree rotation
# Waveshare_Rotate=90, #90 degree rotation
# Waveshare_Rotate=180, #180 degree rotation
# Waveshare_Rotate=270, #270 degree rotation

# Add related statement to /boot/config.txt file
# display_rotate=0, #0 degree rotation
# display_rotate=90, #90 degree rotation
# display_rotate=180, #180 degree rotation
# display_rotate=270, #270 degree rotation

cd /opt/dev/linux
make menuconfig
# jump to "Device Drivers" --> "Input device support" --> "Touchscreen"
# choose "WaveShare_WS_7inch_C" and press "y" to compile 

make -j4 zImage modules dtbs
sudo make modules_install
sudo cp arch/arm/boot/dts/*.dtb /boot/
sudo cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/

# for Raspberry Pi 1， Pi0， Pi 0W and Compute Module：
sudo cp arch/arm/boot/zImage /boot/kernel.img

# for Raspberry Pi 2， Pi3 and Compute Module 3
# sudo cp arch/arm/boot/zImage /boot/kernel7.img

sudo reboot now

# reference resource:
# https://www.raspberrypi.org/documentation/linux/kernel/building.md
