# mobile_dev_plus_test_2017_esp8266
ESP 8266 Mobile Dev Plus Test code

## Install Drivers for Nodemcu Module

https://www.silabs.com/products/development-tools/software/usb-to-uart-bridge-vcp-drivers

## Get Esplorer

https://esp8266.ru/esplorer/

You will need to have Java installed to use this.

## Download Esptool 

https://nodemcu.readthedocs.io/en/master/en/flash/

You will need python for this to work

## Flash the firmware

If you are on a mac this will be your port, if you are on Windows or Linux these will be different.

esptool.py --port /dev/cu.SLAB_USBtoUART write_flash -fm dio 0x00000 nodemcu-master-19-modules-2017-04-16-05-19-04-float.bin 

Once the flashing is done wait a minute to make sure that everything is good.

## start esplorer

java -jar Esplorer.jar

# Using a connected device

You will want to read the documents to set up your wifi as saved settings that auto connect to your wifi hotspot.

After doing this upload the init.lua script using the upload script to upload it to the device as this filename. After that the script will run whenever the device is powered up and has connectivity. It displays a pattern sent to it for one second and then reverts to a rainbow. You will need to modify the SERVER variable to point to your server that is running the companion node.js app that can be found at https://github.com/lgleasain/mobile_dev_plus_test_2017_nodejs . Instructions can be found on how to send paterns to the device over there.
