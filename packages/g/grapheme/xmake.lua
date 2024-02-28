
local function getVersion(version)
    local versions ={
        ["2023.12.01"] = "archive/c8b34aa04ac8702e55ba4b8946d6794c9c6056f5.tar.gz",
    }
    return versions[tostring(version)]
end

package("grapheme")
    set_homepage("https://github.com/FRIGN/libgrapheme")
    set_description("libgrapheme is an extremely simple freestanding C99 library providing utilities for properly handling strings according to the latest Unicode standard 15.0.0. It offers fully Unicode compliant")
    set_license("ISC")
    set_urls("https://github.com/FRIGN/libgrapheme/$(version)", {
        version = getVersion
    })

    add_versions("2023.12.01", "4b51172351f3be4ea45361e7f76fe7b03e7cf509c868529a83fa737ed3985d3e")
    on_install(function (package)
            io.writefile(
            "xmake.lua",
[[
add_rules("mode.debug", "mode.release")
if is_plat("windows") then
    add_cxflags("/utf-8")
end

local gens = {
    "bidirectional",
    "case",
    "character",
    "line",
    "sentence",
    "word",
}
target("gen_util")
    set_kind("object")
    set_plat(os.host())
    set_arch(os.arch())
    add_files("gen/util.c")
target_end()

for _, name in ipairs(gens) do
    target("gen_"..name)
        set_kind("binary")
        set_plat(os.host())
        set_arch(os.arch())
        add_files("gen/"..name..".c")
        add_deps("gen_util")
    target_end()
end
]],
            {encoding = "binary"}
        )
        import("package.tools.xmake").install(package, {})
        for _, name in ipairs({
            "bidirectional",
            "case",
            "character",
            "line",
            "sentence",
            "word",
        }) do
            print("generate "..name..".h……")
            local outdata, errdata = os.iorunv(package:installdir("bin").."/gen_"..name)
            io.writefile("gen/"..name..".h", outdata, {encoding = "binary"})
        end
        io.writefile(
            "xmake.lua",
[[
add_rules("mode.debug", "mode.release")
if is_plat("windows") then
    add_cxflags("/utf-8")
end

target("grapheme")
    set_kind("$(kind)")
    add_files("src/*.c")

    add_headerfiles("grapheme.h")
]],
            {encoding = "binary"}
        )
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("grapheme_decode_utf8", {includes = {"grapheme.h"}}))
    end)
