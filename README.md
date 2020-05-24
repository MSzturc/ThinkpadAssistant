<div><img src="ThinkpadAssistant/Assets.xcassets/AppIcon.appiconset/thinkpadkeyboard1-64.png" width="48" height="48" align="left"/><h1>Thinkpad Assistant</h1></div>
An Assistant Application that allows you to use all your Function Keys on a T-Series Thinkpad Laptop

## Discussion

- [Hackintosh-Forum.de](https://www.hackintosh-forum.de/forum/thread/47983-tool-thinkpad-assistant/) in German
- [InsanelyMac.com](https://www.insanelymac.com/forum/topic/343588-tool-thinkpad-assistant/) in English

## Features

- <b>F4</b>: Mute / Unmute Microphone (with Status LED indication)
- <b>F7</b>: Screen mirroring / Screen extending
- <b>F8</b>: Activate / Deactivate Wi-Fi
- <b>Left Shift+F8</b>: Activate / Deactivate Bluetooth
- <b>F9</b>: Open System Preferences
- <b>F12</b>: Open Launchpad

## Demo
![Demo](Screens/demo.gif)

## Installation

### Opencore
1. Get a pair of Patch & SSDT from [Samples](https://github.com/MSzturc/ThinkpadAssistant/tree/master/Samples) folder
2. Compile SSDT (ex. iasl -vo SSDT-T460-KBRD.dsl)
3. Copy SSDT.aml to EFI/OC/ACPI
4. Apply patch on config.plst with PlistBuddy
5. Download Thinkpad Assistant
6. Extract & Copy to Applications folder
7. Start Thinkpad Assistant & Tick 'Launch on Login' in Menubar
8. Reboot


### Clover
1. Get a pair of Patch & SSDT from [Samples](https://github.com/MSzturc/ThinkpadAssistant/tree/master/Samples) folder
2. Compile SSDT (ex. iasl -vo SSDT-T460-KBRD.dsl)
3. Copy SSDT.aml to EFI/CLOVER/ACPI/patched
4. Apply patch on config.plst with PlistBuddy
5. Download Thinkpad Assistant
6. Extract & Copy to Applications folder
7. Start Thinkpad Assistant & Tick 'Launch on Login' in Menubar
8. Reboot

## Tester & working Configs


| Config | Tester | Bootloader | Image
| ------ | ------ | ------ | ------ |
| [T460](https://github.com/MSzturc/ThinkpadAssistant/tree/master/Samples/T460) | [MSzturc](https://github.com/MSzturc) | OpenCore | [Lenovo-T460-OpenCore](https://github.com/MSzturc/Lenovo-T460-OpenCore)
| [T480](https://github.com/MSzturc/ThinkpadAssistant/tree/master/Samples/T480) | [EETagent](https://https://github.com/EETagent) | OpenCore | [T480-OpenCore-Hackintosh](https://github.com/EETagent/T480-OpenCore-Hackintosh)
| [X1C6](https://github.com/MSzturc/ThinkpadAssistant/tree/master/Samples/X1C6) | [tylernguyen](https://github.com/tylernguyen) | OpenCore / Clover | [x1c6-hackintosh](https://github.com/tylernguyen/x1c6-hackintosh)
| [T440p](https://github.com/MSzturc/ThinkpadAssistant/tree/master/Samples/T440p) | [pandel](https://www.hackintosh-forum.de/user/52804-pandel/) | Clover | - 
| T460s | [simprecicchiani](https://github.com/simprecicchiani) | OpenCore | [Thinkpad-T460s-macOS-OpenCore](https://github.com/simprecicchiani/Thinkpad-T460s-macOS-OpenCore) 


/
