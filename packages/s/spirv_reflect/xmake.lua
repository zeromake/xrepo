package("spirv_reflect")
    set_homepage("Todo")
    set_description("Todo")
    set_license("MIT")
    set_urls("https://github.com/KhronosGroup/SPIRV-Reflect/archive/refs/tags/sdk-$(version).1.tar.gz")

    add_versions("1.3.250", "aa0f202227d6e6f3f78c0e181ca57184c4491069588b284809c5ea99ef6f0440")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("spvReflectCreateShaderModule", {includes = {"spirv_reflect.h"}}))
    end)
