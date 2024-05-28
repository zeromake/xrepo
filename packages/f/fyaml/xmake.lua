local function getVersion(version)
    local versions ={
        ["2024.04.22-alpha"] = "archive/8d7712ca34b9b6542bd7bdca5a82663a3d87021f.tar.gz",
    }
    return versions[tostring(version)]
end
package("fyaml")
    set_homepage("https://github.com/pantoniou/libfyaml")
    set_description("Fully feature complete YAML parser and emitter, supporting the latest YAML spec and passing the full YAML testsuite.")
    set_license("MIT")
    set_urls("https://github.com/pantoniou/libfyaml/$(version)", {
        version = getVersion
    })

    add_versions("2024.04.22-alpha", "1fff345a7763e0cac8d3949f5685d94c32f0867a09d856d5b500ac88eed5a433")
    on_install(function (package)
        io.writefile("xmake.lua", [[
includes("@builtin/check")
add_rules("mode.debug", "mode.release")
if is_plat("windows") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("b3portable")
    set_kind("object")
    add_defines(
        "HASHER_SUFFIX=portable",
        "SIMD_DEGREE=1"
    )
    add_files(
        "src/blake3/blake3_portable.c",
        "src/blake3/blake3.c"
    )
    add_includedirs(
        "include",
        "src/util",
        "src/thread"
    )

target("fyaml")
    set_kind("$(kind)")
    add_files(
        "src/lib/*.c",
        "src/util/*.c",
        "src/xxhash/*.c",
        "src/thread/*.c"
    )
    add_includedirs(
        "include",
        "src/lib",
        "src/util",
        "src/thread",
        "src/xxhash"
    )
    add_headerfiles("include/libfyaml.h")
    check_cincludes("HAVE_BYTESWAP_H", "byteswap.h")
    check_cfuncs("HAVE___BUILTIN_BSWAP16", "__builtin_bswap16", {includes = "byteswap.h"})
    check_cfuncs("HAVE___BUILTIN_BSWAP32", "__builtin_bswap32", {includes = "byteswap.h"})
    check_cfuncs("HAVE___BUILTIN_BSWAP64", "__builtin_bswap64", {includes = "byteswap.h"})
    add_files(
        "src/blake3/blake3_host_state.c",
        "src/blake3/blake3_backend.c",
        "src/blake3/blake3_be_cpusimd.c",
        "src/blake3/fy-blake3.c"
    )
    add_deps("b3portable")
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("fy_version_compare", {includes = {"libfyaml.h"}}))
    end)
