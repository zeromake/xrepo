local function getVersion(version)
    local versions ={
        ["2023.07.01-alpha"] = "archive/1adfdf5cd5447c68e11b0ab9f74318a4e364e7c9.tar.gz",
        ["2024.08.12-alpha"] = "archive/a9e2f30b04f10df1912d06ff5a610edda4677ba5.tar.gz",
        ["2025.01.11-alpha"] = "archive/fd7e70a7a25c80b09e697c8e9256d51c370d5496.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("mojoal")
    set_homepage("https://icculus.org/mojoAL")
    set_description("An SDL2-based implementation of OpenAL in a single C file.")
    set_license("zlib")
    set_urls("https://github.com/icculus/mojoAL/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2025.01.11-alpha", "a64c60357f15eebba18ead06f4c8bbca5c90a6542095d38e1e4b77138b04af76")
    add_versions("2024.08.12-alpha", "06bdc0dc73fd8143aa22f1af04b419451ba7637fdc6ff5a9f078e1e36784d15a")
    add_versions("2023.07.01-alpha", "83620b1a78a76cdb7e2c51f1e41e0978e0ef4071e4bbc48fe251a2fee2c69e3c")
    add_deps("sdl2")
    on_load(function (package)
        if package:config("shared") ~= true then
            package:add("defines", "AL_LIBTYPE_STATIC")
        end
    end)
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

add_requires("sdl2")

target("mojoal")
    set_kind("$(kind)")
    add_files("mojoal.c")
    add_includedirs("AL")
    add_packages("sdl2")
    add_headerfiles("AL/*.h", {prefixdir = "AL"})
    if is_kind("static") then
        add_defines("AL_LIBTYPE_STATIC")
    end
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("alSourcePlay", {includes = {"AL/al.h"}}))
    end)
