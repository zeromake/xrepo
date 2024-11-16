local function getVersion(version)
    local versions ={
        ["2024.10.30-alpha"] = "archive/bf41c8a4f09576d42ca1b975cfa355d4709cecb1.tar.gz",
        ["2024.11.05-alpha"] = "archive/a0183472e012867077e09c7531693e30388752b2.tar.gz",
        ["2024.11.13-alpha"] = "archive/9040e0d25dc545a6d725276bdbd0362791c81f14.tar.gz",
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
