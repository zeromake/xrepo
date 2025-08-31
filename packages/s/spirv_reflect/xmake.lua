local function getVersion(version) 
    return tostring(version):gsub('-release', '')
end

package("spirv_reflect")
    set_homepage("https://github.com/KhronosGroup/SPIRV-Reflect")
    set_description("SPIRV-Reflect is a lightweight library that provides a C/C++ reflection API for SPIR-V shader bytecode in Vulkan applications.")
    set_license("MIT")
    set_urls("https://github.com/KhronosGroup/SPIRV-Reflect/archive/refs/tags/vulkan-sdk-$(version).tar.gz", {
        version = getVersion
    })

    --insert version
    add_versions("1.4.321-release.0", "254ed36128e7abe8fb12ef804319d0790e059093c116e9fe55d4003880515f85")
    add_versions("1.4.313-release.0", "a72129e23ffdf98978b0e60fcf24a14039503383cb077462677a1c59ffd168f0")
    add_versions("1.4.309-release.0", "ee57238d4a2c0abf7f0641fb5143bde211e8e31a94194458bab2b6b0a97cb282")
    add_versions("1.4.304-release.1", "db1e03bec2901d6552d7d255b09b1ecc4bbc46b623d44529a04a2f164648cc14")
    add_versions("1.3.296-release.0", "4a8a43a1210e9eb086174a3d6e4087eb393bf1f2ff3495a91c7386b862cbe193")
    add_versions("1.3.290-release.0", "289b8ba405a2854c5b5231e50034b511a99dd4a6fabd159fd3b30b35a87876a6")
    add_versions("1.3.283-release.0", "ae8cf36d155e5c62536ec6a2b215d479ef5677e447802ec69250efb4ee5ca447")
    add_versions("1.3.280-release.0", "23934b12e528096d678a318f6590a48f5e0e97d4a89d8146b4fddf48f4ff689a")
    add_versions("1.3.275-release.0", "0fe4430cd3a594772a88ba5ed96bb35992c0674cc2461a68d0d6e6586d9f10ba")
    add_versions("1.3.250-release.1", "aa0f202227d6e6f3f78c0e181ca57184c4491069588b284809c5ea99ef6f0440")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("spvReflectCreateShaderModule", {includes = {"spirv_reflect.h"}}))
    end)
