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

## Full light up badge Parts List

* ESP8266 NodeMCU module 
* RGB 4x4 WS2812 LED module
* 74AHCT125 voltage leveler chip
* 7 pieces of wire
* [3D printed Case](https://www.thingiverse.com/thing:1128026/#files)
* portable battery ![](https://i.ebayimg.com/images/i/182463930596-0-0/s-l140/p.jpg) ![](https://assets.pcmag.com/media/images/530904-radioshack-lipstick-portable-power-bank.jpg?thumb=y&width=333&height=245)

## Wiring Diagram

![](https://raw.githubusercontent.com/lgleasain/mobile_dev_plus_test_2017_esp8266/master/wiring_diagram.png)

# License/Copyright

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](http://creativecommons.org/licenses/by-nc-sa/4.0/)
