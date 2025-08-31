local function getVersion(version)
    local versions ={
        ["2024.08.10-alpha"] = "archive/9c9d34558cc438f99aebd1ab58f83fd7faeabc0a.tar.gz",
        ["2024.10.26-alpha"] = "archive/da9aeda08c3ff710a0d47d61a079f5a905b0a10a.tar.gz",
        ["2025.01.28-alpha"] = "archive/82c5609dddbeae1e16b4079bf228fd1647ec4f57.tar.gz",
        ["2025.02.19-alpha"] = "archive/b21e1b9fea935d2f3b94e6d315db1c47a5753199.tar.gz",
        ["2025.02.21-alpha"] = "archive/f20e41de09d97e4461946b7e26ec831d0c24fac7.tar.gz",
        ["2025.06.12-alpha"] = "archive/14d6629bc8a9fe40d8a6bee1bf71c45afe7576b6.tar.gz",
        --insert getVersion
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

    --insert version
    add_versions("2025.06.12-alpha", "f5087993d71367e2644e37f657613ab7a3d90f5fdaf087033491d8a74f61c53c")
    add_versions("2025.02.21-alpha", "5a7b75d18956897e0cb5d2da3b54d0c498bf775b9d0fa2c6955d3e87296b65b3")
    add_versions("2025.02.19-alpha", "515a430b526981823e81832a7d3cece684bb33fc65d3813ce29262f552cb31b3")
    add_versions("2025.01.28-alpha", "f23e8942b94e26650d4b7f5863f928bbfbf3c7106bc1d354067c03d85f5109a3")
    add_versions("2024.10.26-alpha", "87e0712dd1672b6bbb6ff620fe6bbbe85728650ef1bd5bfb82b8d808cc50f2ba")
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
