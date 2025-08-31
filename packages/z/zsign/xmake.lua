local function getVersion(version)
    local versions ={
        ["2024.09.10-alpha"] = "archive/3c23b6192364c12200ba5950ec363d6877f8c920.tar.gz",
        ["2024.12.19-alpha"] = "archive/9fd2942fa9dc5fc5ba111526686b0e4a35aff3a9.tar.gz",
        ["2025.02.13-alpha"] = "archive/818191e43e230688affa0ca4371aaa536c3fb755.tar.gz",
        ["2025.02.20-alpha"] = "archive/f3224570687bc91bfdbe62938fcf6f5f779907d8.tar.gz",
        ["2025.03.17-alpha"] = "archive/43caac5c0b3f94ed7b5847c2038c529181b0bf11.tar.gz",
        ["2025.07.01-alpha"] = "archive/370b81f9a7ee8ed68dc6ec24822b1ef07e9f2437.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("zsign")
    set_kind("binary")
    set_homepage("https://github.com/zhlynn/zsign")
    set_description("Maybe it is the most quickly codesign alternative for iOS12+, cross-platform ( macOS, Linux , Windows ), more features.")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/zhlynn/zsign/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2025.07.01-alpha", "339a6ca1043ebd9cedd1c576fb0400e898f7c3083b971636d14fd0ece44dc76b")
    add_versions("2025.03.17-alpha", "837f59c4ab6b156f63e58ab1fbf4b911f05fa4b7e54b87b5b8e35cfbde429120")
    add_versions("2025.02.20-alpha", "cd420fc3735f0532e9fc9fef3b0b6aa2c64296e7e0ba7555ece701aab5f1a534")
    add_versions("2025.02.13-alpha", "d780a74c6b2ed36cead7870bf4f15b13a5209982fb169a67d792a4c8874fc614")
    add_versions("2024.12.19-alpha", "1a00368d3a9560981655f9f4e90b062260f030ad246b8febe80b2fc82f642432")
    add_versions("2024.09.10-alpha", "6f60d78cd3c93fef43d02cdc918c674ba62c1a2da7e59b160d830172a3a3c074")
    add_patches("2024.09.10-alpha", path.join(os.scriptdir(), "patches/libressl-1.patch"), "39bd8a723a03dc5a976b47af0cc61aece08a0065322a6457fed1b0c35f8da33a")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end
add_requires("libressl")
target("zsign")
    set_kind("binary")
    add_files("*.cpp", "common/*.cpp")
    add_packages("libressl")
    set_languages("c99", "c++14")
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
