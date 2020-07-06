//
//  Capslock.m
//  ThinkpadAssistant
//
//  Created by Igor Kulman on 05/07/2020.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

#include <IOKit/IOKitLib.h>
#include <IOKit/hidsystem/IOHIDLib.h>
#include <IOKit/hidsystem/IOHIDParameter.h>
#include <CoreFoundation/CoreFoundation.h>
#include <stdbool.h>

#include <libgen.h>

/*!
   @brief Gets the current Capslock state

   @discussion This method can be used the gets the initial Capslock state whhen the application is first run. Needs to be done in Objective-C as Swift can only listen for modifier key presses only do determine Capslock being pressed.

               To use it, simply call getCapslockState()

   @return true if Capslock is enabled, false otherwise
*/
bool getCapslockState()
{
    kern_return_t kr;
    io_service_t ios;
    io_connect_t ioc;
    CFMutableDictionaryRef mdict;
    bool state;

    mdict = IOServiceMatching(kIOHIDSystemClass);
    ios = IOServiceGetMatchingService(kIOMasterPortDefault, (CFDictionaryRef) mdict);
    if (!ios)
    {
        if (mdict)
            CFRelease(mdict);
        return false;
    }

    kr = IOServiceOpen(ios, mach_task_self(), kIOHIDParamConnectType, &ioc);
    IOObjectRelease(ios);
    if (kr != KERN_SUCCESS)
    {
        return false;
    }

    kr = IOHIDGetModifierLockState(ioc, kIOHIDCapsLockState, &state);
    if (kr != KERN_SUCCESS)
    {
        IOServiceClose(ioc);
        return false;
    }

    IOServiceClose(ioc);
    return (bool)state;
}
