
local function getVersion(version)
    local versions ={
        ["2023.05.07"] = "archive/f2aa30ea21a63c9ceeb6393e7d5d0c85a05a52a7.tar.gz",
    }
    return versions[tostring(version)]
end

local exports = {
    "ikcp_create",
    "ikcp_release",
    "ikcp_setoutput",
    "ikcp_recv",
    "ikcp_send",
    "ikcp_update",
    "ikcp_check",
    "ikcp_input",
    "ikcp_flush",
    "ikcp_peeksize",
    "ikcp_setmtu",
    "ikcp_wndsize",
    "ikcp_waitsnd",
    "ikcp_nodelay",
    "ikcp_log",
    "ikcp_allocator",
    "ikcp_getconv",
}

local function join_exports(exports, prefix, suffix)
    local s = ""
    for _, line in ipairs(exports) do
        s = s .. prefix .. line .. suffix
    end
    return s
end

package("kcp")
    set_homepage("https://github.com/skywind3000/kcp")
    set_description("KCP - A Fast and Reliable ARQ Protocol")
    set_license("MIT")
    set_urls("https://github.com/skywind3000/kcp/$(version)", {
        version = getVersion
    })

    add_versions("2023.05.07", "5bfa9fb6de27f23e263be5398dddc443348008a94fd287ece80a5b98207b2e37")
    on_install(function (package)
        io.writefile(
            "exports.def",
            "LIBRARY\n    EXPORTS\n" .. join_exports(exports, "        ", "\n"),
            {encoding = "binary"}
        )
        io.writefile(
            "exports.exp",
            join_exports(exports, "_", "\n"),
            {encoding = "binary"}
        )
        io.writefile(
            "exports.map",
            "{\nglobal:\n" .. join_exports(exports, "    ", ";\n") .. "local:\n    *;\n};\n",
            {encoding = "binary"}
        )
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

target("kcp")
    set_kind("$(kind)")
    add_files("ikcp.c")
    add_headerfiles("ikcp.h")
    if is_plat("windows", "mingw") then
        add_files("exports.def")
    else
        add_cflags("-fPIC")
        on_config(function(target)
            local is_clang = not not (target:toolchain("clang") or target:toolchain("clang-cl"))
            if is_clang then
                target:add("shflags", "-exported_symbols_list exports.exp", {force = true})
            else
                target:add("cflags", "-fvisibility=hidden")
                target:add("shflags", "--version-script=exports.map")
            end
        end)
    end
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
