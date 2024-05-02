local function getVersion(version)
    local versions ={
        ["2019.03.08-alpha"] = "archive/752b62685aff0c79ffc56c090a4cbb1ec82dfd61.tar.gz",
    }
    return versions[tostring(version)]
end

package("subsync")
    set_kind("binary")
    set_homepage("https://github.com/xuminic/subsync")
    set_description("synchronize .srt or .ssa subtitles with the video timeline")
    set_license("GPL-3.0")
    set_urls("https://github.com/xuminic/subsync/$(version)", {version = getVersion})

    add_versions("2019.03.08-alpha", "af95437827ceb14467702bc502584f72489dfd99625b68ee6c04b1883ea01668")
    on_install(function (package)
    io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
target("subsync")
    add_files("subsync.c")
    add_includedirs(".")
]], {encoding = "binary"})
    if is_plat("windows", "mingw") then
        io.writefile("unistd.h", [[
#ifndef _UNISTD_H
#define _UNISTD_H
#include <io.h>
#include <process.h>
#ifndef F_OK
#define F_OK 0x04
#endif
#endif /* _UNISTD_H */]], {encoding = "binary"})
    end
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
