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
    add_versions("24.08.0", "aa04aac906a04df59e7301f4c69e9f48808e6c8ecae4eb697703a47bfb0ac042")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
