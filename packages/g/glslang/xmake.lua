package("glslang")
    set_homepage("https://github.com/KhronosGroup/glslang")
    set_description("Khronos-reference front end for GLSL/ESSL, partial front end for HLSL, and a SPIR-V generator.")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/KhronosGroup/glslang/archive/refs/tags/$(version).tar.gz")

    --insert version
    add_versions("14.3.0", "be6339048e20280938d9cb399fcdd06e04f8654d43e170e8cce5a56c9a754284")
    add_versions("14.2.0", "14a2edbb509cb3e51a9a53e3f5e435dbf5971604b4b833e63e6076e8c0a997b5")
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
