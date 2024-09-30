local function getVersion(version)
    return tostring(version):gsub('-release', '')
end
package("spirv_headers")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/KhronosGroup/SPIRV-Headers")
    set_description("SPIRV-Headers")
    set_license("MIT")
    set_urls("https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-$(version).tar.gz", {
        version = getVersion
    })

    --insert version
    add_versions("1.3.290-release.0", "1b9ff8a33e07814671dee61fe246c67ccbcfc9be6581f229e251784499700e24")
    add_versions("1.3.283-release.0", "a68a25996268841073c01514df7bab8f64e2db1945944b45087e5c40eed12cb9")
    on_install(function (package)
        os.cp("include/spirv", package:installdir("include"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
