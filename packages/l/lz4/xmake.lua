
package("lz4")
    set_homepage("https://lz4.org")
    set_description("Extremely Fast Compression algorithm")
    set_license("BSD-2-Clause")
    set_urls("https://github.com/lz4/lz4/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("1.10.0", "537512904744b35e232912055ccf8ec66d768639ff3abe5788d90d792ec5f48b")
    add_versions("1.9.4", "0b0e3aa07c8c063ddf40b082bdf7e37a1562bda40a0ff5272957f3e987e0e54b")

    on_load(function (package)
        if package:is_plat("windows") and package:config("shared") == true then
            package:add("defines", "LZ4_DLL_EXPORT=1")
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("LZ4_compress_default", {includes = {"lz4.h"}}))
    end)
