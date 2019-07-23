# SwiftyXBeeExample

A simple example of how to communicate with XBee (ZigBee Series 2) radios in API mode.

⚠️ If you want to run the example code, make sure to use an actual XBee serial number when defining:
```swift
let deviceAddress = DeviceAddress(address: 0x0013A20012345678)
```
You can find the XBee's serial number on the back of the device, or by copying it directly from the [XCTU tool](https://www.digi.com/resources/documentation/digidocs/90001526/tasks/t_download_and_install_xctu.htm).
