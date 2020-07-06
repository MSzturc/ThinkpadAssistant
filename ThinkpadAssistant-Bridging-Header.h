//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include <stdbool.h>

int IOBluetoothPreferenceGetControllerPowerState();
void IOBluetoothPreferenceSetControllerPowerState(int state);

bool getCapslockState();
