local function getVersion(version)
    local versions ={
        ["2024.06.18-alpha"] = "archive/5d127b917f080c6f052553c47170ec0ba702e54f.tar.gz",
        ["2024.06.19-alpha"] = "archive/6fd1f75636b1c424b809ad8a84804654cf5ae48b.tar.gz",
        ["2024.09.10-alpha"] = "archive/f84c1fbe3cbb69fa99e9115f658e52df0e95f1bf.tar.gz",
        ["2024.09.25-alpha"] = "archive/b28b3559d3882f918825cd90342dcfa955770bad.tar.gz",
        ["2024.10.15-alpha"] = "archive/e670b39cfced2f7258c73dc7cd708c6c639beaf0.tar.gz",
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
    add_versions("2024.10.15-alpha", "4836d8f95dc8904fa0749c42e0bae1f3870ede8dd50acf69aca15725b137e6f9")
    add_versions("2024.09.25-alpha", "36440037c03e7f50a7597ea934833b56dbfcb2c5d80ab0129aff099ba9b61c5c")
    add_versions("2024.09.10-alpha", "baca43df685661e8f07911ba9de22c515f3849ea2d6c8bfa309ed01b7fe7f618")
    add_versions("2024.06.19-alpha", "0633c4e8dbd2cff0c0d90fe16b0ab68d94a796dad9f84a90bf84830c0f2aeec2")
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
