// SSDT for T480 Keyboard Map & Configuration.

DefinitionBlock ("", "SSDT", 2, "T480", "KBRD", 0x00000000)
{
    External (_SB_.PCI0.LPCB.EC__, DeviceObj)
    External (_SB_.PCI0.LPCB.EC__.HKEY.MMTS, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.EC__.XQ14, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.EC__.XQ15, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.EC__.XQ16, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.EC__.XQ64, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.EC__.XQ66, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.EC__.XQ67, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.EC__.XQ68, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.EC__.XQ69, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.EC__.XQ6A, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.KBD_, DeviceObj)

    Scope (\_SB.PCI0.LPCB.EC)
    {
        Name (LED1, Zero)
        Method (_Q6A, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                If ((LED1 == Zero))
                {
                    Notify (\_SB.PCI0.LPCB.KBD, 0x0136)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x036B)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x01B6)
                    \_SB.PCI0.LPCB.EC.HKEY.MMTS (0x02)
                    LED1 = One
                }
                Else
                {
                    Notify (\_SB.PCI0.LPCB.KBD, 0x012A)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x036B)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x01AA)
                    \_SB.PCI0.LPCB.EC.HKEY.MMTS (Zero)
                    LED1 = Zero
                }
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ6A ()
            }
        }

        Method (_Q15, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPCB.KBD, 0x0405)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ15 ()
            }
        }

        Method (_Q14, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPCB.KBD, 0x0406)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ14 ()
            }
        }

        Method (_Q16, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPCB.KBD, 0x0367)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ16 ()
            }
        }

        Method (_Q64, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPCB.KBD, 0x0368)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ64 ()
            }
        }

        Method (_Q66, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPCB.KBD, 0x0369)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ66 ()
            }
        }

        Method (_Q67, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPCB.KBD, 0x0138)
                Notify (\_SB.PCI0.LPCB.KBD, 0x0339)
                Notify (\_SB.PCI0.LPCB.KBD, 0x01B8)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ67 ()
            }
        }

        Method (_Q68, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPCB.KBD, 0x011D)
                Notify (\_SB.PCI0.LPCB.KBD, 0x0448)
                Notify (\_SB.PCI0.LPCB.KBD, 0x019D)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ68 ()
            }
        }

        Method (_Q69, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPCB.KBD, 0x036A)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ69 ()
            }
        }
    }

    Scope (\_SB.PCI0.LPCB.KBD)
    {
        If (_OSI ("Darwin"))
        {
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If (!Arg2)
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                Return (Package (0x04)
                {
                    "RM,oem-id",
                    "LENOVO",
                    "RM,oem-table-id",
                    "T460"
                })
            }

            Name (RMCF, Package (0x02)
            {
                "Keyboard",
                Package (0x0A)
                {
                    "ActionSwipeLeft",
                    "37 d, 21 d, 21 u, 37 u",
                    "ActionSwipeRight",
                    "37 d, 1e d, 1e u, 37 u",
                    "SleepPressTime",
                    "1500",
                    "Swap command and option",
                    ">y",
                    "Custom PS2 Map",
                    Package (0x03)
                    {
                        Package (0x00){},
                        "e038=e05b",
                        "e037=64"
                    }
                }
            })
        }
    }
}
