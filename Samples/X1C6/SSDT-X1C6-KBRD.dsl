// SSDT for X1C6 Keyboard Map & Configuration.

DefinitionBlock("", "SSDT", 2, "OCLT", "x1input", 0)
{
    External(\_SB.PCI0.LPCB.KBD, DeviceObj)
    External(\_SB.PCI0.LPCB.EC, DeviceObj)
    External (\_SB.PCI0.LPCB.EC.XQ14, MethodObj)
    External (\_SB.PCI0.LPCB.EC.XQ15, MethodObj)
    External (\_SB.PCI0.LPCB.EC.XQ16, MethodObj)
    External (\_SB.PCI0.LPCB.EC.XQ1F, MethodObj)
    External (\_SB.PCI0.LPCB.EC.XQ60, MethodObj)
    External (\_SB.PCI0.LPCB.EC.XQ61, MethodObj)
    External (\_SB.PCI0.LPCB.EC.XQ62, MethodObj)
    External (\_SB.PCI0.LPCB.EC.XQ64, MethodObj)
    External (\_SB.PCI0.LPCB.EC.XQ66, MethodObj)
    External (\_SB.PCI0.LPCB.EC.XQ6A, MethodObj)
    External (\_SB.PCI0.LPCB.EC.XQ74, MethodObj)
    External (\_SB.PCI0.LPCB.EC.HKEY.MMTS, MethodObj)
    External (\_SB.PCI0.LPCB.EC.HKEY.MCLS, MethodObj)
    External (\_SB.PCI0.LPCB.EC.HKEY.MHKQ, MethodObj)

    Scope (_SB.PCI0.LPCB.EC)
    {
        Name (MICL, Zero) // Microphone Mute
        Name (KEYL, Zero) // Keyboard Backlight
	Name (FUNL, Zero) // FnLock

        // _Q6A - Microphone Mute
        Method (_Q6A, 0, Serialized) // F4 - Microphone Mute = F20
        {
            If (!_OSI("Darwin")) {
                XQ6A()
                Return()    
            }
            
            MICL = (MICL + 1) % 2
            
            Switch (MICL)
            {
                Case (One) {
                    // Right Shift + F20
                    Notify (\_SB.PCI0.LPCB.KBD, 0x0136)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x036B)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x01b6)
                    
                    // Enable LED
                    \_SB.PCI0.LPCB.EC.HKEY.MMTS (0x02)
                }
                Case (Zero) {
                    // Left Shift + F20
                    Notify (\_SB.PCI0.LPCB.KBD, 0x012A)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x036B)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x01aa)
                    
                    // Disable LED
                    \_SB.PCI0.LPCB.EC.HKEY.MMTS (Zero)
                }
            }
        }

        Method (_Q15, 0, NotSerialized) // F5 - Brightness Down = F14
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0405)
                Notify(\_SB.PCI0.LPCB.KBD, 0x20)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ15()
            }
        }

        Method (_Q14, 0, NotSerialized) // F6 - Brightness Up = F15
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0406)
                Notify(\_SB.PCI0.LPCB.KBD, 0x10)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ14()
            }
        }

        Method (_Q16, 0, NotSerialized) // F7 - Dual Display = F16
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0367)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ16()
            }
        }

        Method (_Q64, 0, NotSerialized) // F8 - Network = F17
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0368)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ64()
            }
        }

        Method (_Q66, 0, NotSerialized) // F9 - Settings = F18
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0369)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ66()
            }
        }

        Method (_Q60, 0, NotSerialized) // F10 - Bluetooth
        {

            If (_OSI ("Darwin"))
            {
                // Left Shift + F17
                Notify (\_SB.PCI0.LPCB.KBD, 0x012A)
                Notify (\_SB.PCI0.LPCB.KBD, 0x0368)
                Notify (\_SB.PCI0.LPCB.KBD, 0x01AA)
            }
            Else
            {
                // Call original _Q60 method.
                \_SB.PCI0.LPCB.EC.XQ60()
            }
        }

        Method (_Q61, 0, NotSerialized) // F11 - Keyboard
        {
            If (_OSI ("Darwin"))
            {
                // Send a down event for the Control key (scancode 1d), then a one-shot event (down then up) for
                // the up arrow key (scancode 0e 48), and finally an up event for the Control key (break scancode 9d).
                // This is picked up by VoodooPS2 and sent to macOS as the Control+Up key combo.
                Notify (\_SB.PCI0.LPCB.KBD, 0x011D)
                Notify (\_SB.PCI0.LPCB.KBD, 0x0448)
                Notify (\_SB.PCI0.LPCB.KBD, 0x019D)
            }
            Else
            {
                // Call original _Q61 method.
                \_SB.PCI0.LPCB.EC.XQ61()
            }
        }

        Method (_Q62, 0, NotSerialized) // F12 - Star = F19
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x036A)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ62()
            }
        }

	// _Q74 - FnLock
        Method (_Q74, 0, Serialized) // FnLock = Shift + F18
        {
            If (!_OSI("Darwin")) {
                XQ74()
                Return()
            }

            FUNL = (FUNL + 1) % 2

            Switch (FUNL)
            {
                Case (One) {
                    // Right Shift + F18
                    Notify (\_SB.PCI0.LPCB.KBD, 0x012A)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x0369)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x01aa)

                    // Enable LED
                    \_SB.PCI0.LPCB.EC.HKEY.MHKQ (0x02)
                }
                Case (Zero) {
                    // Left Shift + F18
                    Notify (\_SB.PCI0.LPCB.KBD, 0x0136)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x0369)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x01b6)

                    // Disable LED
                    \_SB.PCI0.LPCB.EC.HKEY.MHKQ (Zero)
                }
            }
        }

        // _Q1F - (Fn+Space) Toggle Keyboard Backlight.
        Method (_Q1F, 0, Serialized) // cycle keyboard backlight
        {
            If (!_OSI("Darwin")) {
                XQ1F()
                Return()    
            }
            
            KEYL = (KEYL + 1) % 3
            
            Switch (KEYL)
            {
                Case (Zero) {
                    // Left Shift + F16
                    Notify (\_SB.PCI0.LPCB.KBD, 0x012a)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x0367)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x01aa)
                    
                    // Off
                    \_SB.PCI0.LPCB.EC.HKEY.MCLS (Zero)
                }
                Case (One) {
                    // Right Shift + F16
                    Notify (\_SB.PCI0.LPCB.KBD, 0x0136)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x0367)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x01b6)
                    
                    // Dim
                    \_SB.PCI0.LPCB.EC.HKEY.MCLS (One)
                }
                Case (0x02) {
                    // Left Shift + F19
                    Notify (\_SB.PCI0.LPCB.KBD, 0x012a)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x036a)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x01aa)
                    
                    // Bright
                    \_SB.PCI0.LPCB.EC.HKEY.MCLS (0x02)
                }
            }
        }
    }

    Scope (_SB.PCI0.LPCB.KBD)
    {
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "RM,oem-id", "LENOVO",
                "RM,oem-table-id", "Thinkpad_ClickPad",
            })
        }

        // Overrides (the example data here is default in the Info.plist)
        Name(RMCF, Package()
        {
            "Synaptics TouchPad", Package()
            {
                "BogusDeltaThreshX", 800,
                "BogusDeltaThreshY", 800,
                "Clicking", ">y",
                "DragLockTempMask", 0x40004,
                "DynamicEWMode", ">n",
                "FakeMiddleButton", ">n",
                "HWResetOnStart", ">y",
                //"ForcePassThrough", ">y",
                //"SkipPassThrough", ">y",
                "PalmNoAction When Typing", ">y",
                "ScrollResolution", 800,
                "SmoothInput", ">y",
                "UnsmoothInput", ">y",
                "Thinkpad", ">y",
                "EdgeBottom", 0,
                "FingerZ", 30,
                "MaxTapTime", 100000000,
                "MouseMultiplierX", 2,
                "MouseMultiplierY", 2,
                "MouseScrollMultiplierX", 2,
                "MouseScrollMultiplierY", 2,
                //"TrackpointScrollYMultiplier", 1, //Change this value to 0xFFFF in order to inverse the vertical scroll direction of the Trackpoint when holding the middle mouse button.
                //"TrackpointScrollXMultiplier", 1, //Change this value to 0xFFFF in order to inverse the horizontal scroll direction of the Trackpoint when holding the middle mouse button.
            },

            "Keyboard", Package()
            {
                "Custom PS2 Map", Package()
                {
                    Package() { },
                    "e037=64", // PrtSc = F13
                    "46=80",   // Fn + K = Deadkey
                    "e045=80", // Fn + P = Deadkey
                    "38=e05b", // Left Alt (mismapped to Left GUI by default) = Left Alt
                    "e038=e05c", // Right Alt (mismapped to Right GUI by default) = Right Alt
                    "e05b=38", // Windows (mismapped to Left Alt by default) = Left GUI
                    // "1d=80", // Fn + B = Deadkey
                    // "54=80", // Fn + S = Deadkey
                },
            },
        })
    }
}
//EOF
