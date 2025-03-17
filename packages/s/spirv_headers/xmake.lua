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
    add_versions("1.4.309-release.0", "a96f8b4f2dfb18f7432e5c523e220ab0075372a9509e0c25fbff21c76af0de7c")
    add_versions("1.4.304-release.1", "66e6cec19e7433fc58ace8cdf4040be0d52bb5920e54109967df2dd9598a8d48")
    add_versions("1.3.296-release.0", "1423d58a1171611d5aba2bf6f8c69c72ef9c38a0aca12c3493e4fda64c9b2dc6")
    add_versions("1.3.290-release.0", "1b9ff8a33e07814671dee61fe246c67ccbcfc9be6581f229e251784499700e24")
    add_versions("1.3.283-release.0", "a68a25996268841073c01514df7bab8f64e2db1945944b45087e5c40eed12cb9")
    on_install(function (package)
        os.cp("include/spirv", package:installdir("include"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
