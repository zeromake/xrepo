local function getVersion(version)
    local versions ={
        ["2024.10.30-alpha"] = "archive/bf41c8a4f09576d42ca1b975cfa355d4709cecb1.tar.gz",
        ["2024.11.05-alpha"] = "archive/a0183472e012867077e09c7531693e30388752b2.tar.gz",
        ["2024.11.13-alpha"] = "archive/9040e0d25dc545a6d725276bdbd0362791c81f14.tar.gz",
        ["2024.12.13-alpha"] = "archive/6173e24b31f09a0c3217103a130e74c4ddec14a6.tar.gz",
        ["2025.01.02-alpha"] = "archive/104d91a9c386b7e4b60463e1b3c51aa353c4c4bc.tar.gz",
        ["2025.02.12-alpha"] = "archive/5fce5915d8f6b662501bfeb8b36f9b8918c6f813.tar.gz",
        ["2025.02.18-alpha"] = "archive/2c32b6bf86f3c4a5539aa1f0bacbd59fe61759cf.tar.gz",
        ["2025.03.10-alpha"] = "archive/1823c119c4d7311469199c1afecf2e255e26eb16.tar.gz",
        ["2025.04.04-alpha"] = "archive/cb71abe3063094bf383379b15473d39cb1144120.tar.gz",
        ["2025.04.24-alpha"] = "archive/7918775748c5e2f5c40d9918ce68825035b5a1e1.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("spirv_cross")
    set_homepage("https://github.com/KhronosGroup/SPIRV-Cross")
    set_description("SPIRV-Cross is a practical tool and library for performing reflection on SPIR-V and disassembling SPIR-V back to high level languages.")
    set_license("Apache-2.0")
    set_urls("https://github.com/KhronosGroup/SPIRV-Cross/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2025.04.24-alpha", "6f18c0ec3e6b8b6ebbf98ed0f210fdb6d19f364c5dbd8556f48071ff4a081955")
    add_versions("2025.04.04-alpha", "0a585ffc35af43e8beadb3d04dad39a79617bffc5652e90bd1530f276b6029d9")
    add_versions("2025.03.10-alpha", "b40d976cf432f198d05fff0792f95213e2ac8927910dacffe90ba3c139d299a7")
    add_versions("2025.02.18-alpha", "1f32df3fc69276d53979f94d253d2b8d7388f55a5ede59f8cc6a308c23e9e0c0")
    add_versions("2025.02.12-alpha", "5a8e6897ac02caf1ed58dbaa8e62f83cc7a9a7630bf2860205f9220d03a13d34")
    add_versions("2025.01.02-alpha", "11b8ab04ceac117b8c161c01dddc2e3593dd6c6a012f3a300370a0fa87bbe0d9")
    add_versions("2024.12.13-alpha", "9021fc583d7f3707ae0416df971e7ebc6eeec934f35b395ab3ecbab664f8703e")
    add_versions("2024.11.13-alpha", "9dfe085080254d2a1a70e1bb0beb6c6355d989d524ae2f8f813cb37e74b25cd0")
    add_versions("2024.11.05-alpha", "a76ce896211fb056246affca577a0874d184b26fd33ca65a691c8360867db45b")
    add_versions("2024.10.30-alpha", "004de9f2ce173058b816241b4fcbfd159ee61f0898b46c0dc49b84a822630252")
    add_configs("cli", {description = "build cli", default = false, type = "boolean"})
    add_includedirs("include", "include/spirv_cross")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        io.writefile("cmake/gitversion.in.h", [[
// Copyright 2016-2021 The Khronos Group Inc.
// SPDX-License-Identifier: Apache-2.0

#ifndef SPIRV_CROSS_GIT_VERSION_H_
#define SPIRV_CROSS_GIT_VERSION_H_

#define SPIRV_CROSS_GIT_REVISION "Git commit: ${spirv-cross-build-version} Timestamp: ${spirv-cross-timestamp}"

#endif]])
        local configs = {}
        configs["cli"] = package:config("cli") and "y" or "n"
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
