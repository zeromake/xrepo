package("sevenzip")
    set_homepage("https://7-zip.org")
    set_description("7-Zip is a file archiver with a high compression ratio.")
    set_license("LGPL")
    set_urls("https://github.com/ip7z/7zip/releases/download/$(version)-src.tar.xz", {
        version = function (version)
            local v = tostring(version)
            v = v:sub(1, #v-2)
            return v.."/7z"..v:gsub("%.", "")
        end
    })
    --insert version
    add_versions("25.01.0", "ed087f83ee789c1ea5f39c464c55a5c9d4008deb0efe900814f2df262b82c36e")
    add_versions("24.09.0", "49c05169f49572c1128453579af1632a952409ced028259381dac30726b6133a")
    add_versions("24.08.0", "aa04aac906a04df59e7301f4c69e9f48808e6c8ecae4eb697703a47bfb0ac042")
    if is_plat("windows", "mingw") then
        add_syslinks("user32", "oleaut32", "advapi32")
    end
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
