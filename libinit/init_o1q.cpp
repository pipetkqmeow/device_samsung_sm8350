/*
   Copyright (C) 2026 The LineageOS Project

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

#include <stdlib.h>
#include <string.h>

#include <android-base/logging.h>
#include <android-base/properties.h>

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "property_service.h"
#include "vendor_init.h"

static void property_override(char const prop[], char const value[])
{
    prop_info* pi;

    pi = (prop_info*)__system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void vendor_load_properties()
{
    const std::string bootloader = android::base::GetProperty("ro.bootloader", "");

    /* Bootloader is G9910ZHSxYYZ on all SM-G9910 variants */
    if (bootloader.substr(0, 5) != "G9910") {
        LOG(ERROR) << "Unexpected bootloader " << bootloader << ", forcing o1q";
    }

    property_override("ro.product.model", "SM-G9910");
    property_override("ro.product.device", "o1q");
    property_override("ro.product.name", "o1qzhx");

    property_override("ro.product.vendor.model", "SM-G9910");
    property_override("ro.product.vendor.device", "o1q");
    property_override("ro.product.vendor.name", "o1qzhx");

    property_override("ro.product.product.model", "SM-G9910");
    property_override("ro.product.product.device", "o1q");
    property_override("ro.product.product.name", "o1qzhx");

    property_override("ro.product.odm.model", "SM-G9910");
    property_override("ro.product.odm.device", "o1q");
    property_override("ro.product.odm.name", "o1qzhx");

    property_override("ro.build.product", "o1q");
    property_override("ro.build.description",
                      "o1qzhx-user 15 AP3A.240905.015.A2 G9910ZHSGHZB1 release-keys");
}
