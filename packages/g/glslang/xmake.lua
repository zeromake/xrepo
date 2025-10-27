package("glslang")
    set_homepage("https://github.com/KhronosGroup/glslang")
    set_description("Khronos-reference front end for GLSL/ESSL, partial front end for HLSL, and a SPIR-V generator.")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/KhronosGroup/glslang/archive/refs/tags/$(version).tar.gz")

    --insert version
    add_versions("16.0.0", "172385478520335147d3b03a1587424af0935398184095f24beab128a254ecc7")
    add_versions("15.4.0", "b16c78e7604b9be9f546ee35ad8b6db6f39bbbbfb19e8d038b6fe2ea5bba4ff4")
    add_versions("15.3.0", "c6c21fe1873c37e639a6a9ac72d857ab63a5be6893a589f34e09a6c757174201")
    add_versions("15.2.0", "45e3920d264d5c2cc3bfaec0e5dbb66cffd549255e0aaaf38cd283918e35c8ba")
    add_versions("15.1.0", "4bdcd8cdb330313f0d4deed7be527b0ac1c115ff272e492853a6e98add61b4bc")
    add_includedirs("include", "include/glslang")
    add_defines("ENABLE_HLSL=1")
    on_install(function (package)
        io.writefile("glslang/build_info.h.in", [[
#ifndef GLSLANG_BUILD_INFO
#define GLSLANG_BUILD_INFO

#define GLSLANG_VERSION_MAJOR ${major}
#define GLSLANG_VERSION_MINOR ${minor}
#define GLSLANG_VERSION_PATCH ${patch}
#define GLSLANG_VERSION_FLAVOR "${flavor}"

#define GLSLANG_VERSION_GREATER_THAN(major, minor, patch) \
    ((GLSLANG_VERSION_MAJOR) > (major) || ((major) == GLSLANG_VERSION_MAJOR && \
    ((GLSLANG_VERSION_MINOR) > (minor) || ((minor) == GLSLANG_VERSION_MINOR && \
     (GLSLANG_VERSION_PATCH) > (patch)))))

#define GLSLANG_VERSION_GREATER_OR_EQUAL_TO(major, minor, patch) \
    ((GLSLANG_VERSION_MAJOR) > (major) || ((major) == GLSLANG_VERSION_MAJOR && \
    ((GLSLANG_VERSION_MINOR) > (minor) || ((minor) == GLSLANG_VERSION_MINOR && \
     (GLSLANG_VERSION_PATCH >= (patch))))))

#define GLSLANG_VERSION_LESS_THAN(major, minor, patch) \
    ((GLSLANG_VERSION_MAJOR) < (major) || ((major) == GLSLANG_VERSION_MAJOR && \
    ((GLSLANG_VERSION_MINOR) < (minor) || ((minor) == GLSLANG_VERSION_MINOR && \
     (GLSLANG_VERSION_PATCH) < (patch)))))

#define GLSLANG_VERSION_LESS_OR_EQUAL_TO(major, minor, patch) \
    ((GLSLANG_VERSION_MAJOR) < (major) || ((major) == GLSLANG_VERSION_MAJOR && \
    ((GLSLANG_VERSION_MINOR) < (minor) || ((minor) == GLSLANG_VERSION_MINOR && \
     (GLSLANG_VERSION_PATCH <= (patch))))))

#endif // GLSLANG_BUILD_INFO
]])
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
