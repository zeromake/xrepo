local function getVersion(version)
    local versions ={
        ["2024.06.18-alpha"] = "archive/5d127b917f080c6f052553c47170ec0ba702e54f.tar.gz",
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

    add_versions("2024.06.18-alpha", "499f3cf3534b882b99614cf855eb92976d15a1cee20f03a234520d10d1f92fb3")
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
