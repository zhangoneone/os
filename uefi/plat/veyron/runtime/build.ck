/*++

Copyright (c) 2015 Minoca Corp.

    This file is licensed under the terms of the GNU General Public License
    version 3. Alternative licensing terms are available. Contact
    info@minocacorp.com for details. See the LICENSE file at the root of this
    project for complete licensing information.

Module Name:

    Veyron UEFI Runtime

Abstract:

    This module implements the RK3288 Veyron runtime firmware, which
    continues to be loaded and provide services to the OS kernel even
    after the boot environment has been destroyed. It is never unloaded.

Author:

    Evan Green 10-Jul-2015

Environment:

    Firmware

--*/

from menv import staticApplication, uefiRuntimeFfs;

function build() {
    var elf;
    var entries;
    var includes;
    var libs;
    var linkConfig;
    var sources;
    var sourcesConfig;

    sources = [
        "i2c.c",
        "pmic.c",
        "reboot.c",
        "rtc.c",
        "runtime.c"
    ];

    libs = [
        "uefi/core/rtlib:rtlib",
        "uefi/archlib:uefiarch"
    ];

    includes = [
        "$S/uefi/include"
    ];

    sourcesConfig = {
        "CFLAGS": ["-fshort-wchar"],
    };

    linkConfig = {
        "LDFLAGS": ["-pie", "-Wl,--no-wchar-size-warning"]
    };

    elf = {
        "label": "veyronrt.elf",
        "inputs": sources + libs,
        "sources_config": sourcesConfig,
        "includes": includes,
        "entry": "EfiRuntimeCoreEntry",
        "linker_script": "$S/uefi/include/link_arm.x",
        "config": linkConfig
    };

    entries = staticApplication(elf);
    entries += uefiRuntimeFfs("veyronrt");
    return entries;
}

