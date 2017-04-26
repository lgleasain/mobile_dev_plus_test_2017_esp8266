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

