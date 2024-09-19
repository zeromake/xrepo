local function getVersion(version)
    local versions ={
        ["2024.08.10-alpha"] = "archive/9c9d34558cc438f99aebd1ab58f83fd7faeabc0a.tar.gz",
    }
    return versions[tostring(version)]
end
package("lmdb")
    set_homepage("https://www.symas.com/symas-embedded-database-lmdb")
    set_description("Lightning Memory-Mapped Database")
    set_license("MIT")
    set_urls("https://github.com/LMDB/lmdb/$(version)", {
        version = getVersion
    })

    add_versions("2024.08.10-alpha", "356165c0edf4b16d5c2606b70dda620c0e8fa1a8e97d0ec7963330dcd7863a70")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
if is_plat("windows") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end
set_encodings("utf-8")
target("lmdb")
    set_kind("$(kind)")
    add_files("libraries/liblmdb/mdb.c", "libraries/liblmdb/midl.c")
    add_headerfiles("libraries/liblmdb/lmdb.h", {prefixdir = "lmdb"})
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("mdb_version", {includes = {"lmdb/lmdb.h"}}))
    end)
