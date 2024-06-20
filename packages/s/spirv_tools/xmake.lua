package("spirv_tools")
    set_homepage("https://github.com/KhronosGroup/SPIRV-Tools")
    set_description("The SPIR-V Tools project provides an API and commands for processing SPIR-V modules.")
    set_license("Apache-2.0")
    set_urls("https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/v$(version).tar.gz")

    add_versions("2024.1", "137780e2a8b5c722888f9ec0fb553e6e92f38a0a5c7fcdad9b715152448b9d82")

    -- add_deps("spirv_headers")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "*.lua"), "./")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
