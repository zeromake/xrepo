
local function getVersion(version)
    local versions ={
        ["2024.11.30-alpha"] = "archive/7f9805887b0909c52c825925f123e7a84da37167.tar.gz",
        ["2025.04.09-alpha"] = "archive/ec72e3471576563e2ff6898ebca716c9f66fd77b.tar.gz",
        ["2025.04.22-alpha"] = "archive/f4f3a89cc632647dabdcb146932d2afd5591e62e.tar.gz",
        --insert getVersion
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

    --insert version
    add_versions("2025.04.22-alpha", "862e1b700542a6f82b73e556fbb2826f4b3257f3da68ce36ff95e64186412559")
    add_versions("2025.04.09-alpha", "c9ea88aeb57531040e8c7e1a7dc1832f6f578064acdaca1e7b0d4c12e44e69df")
    add_versions("2024.11.30-alpha", "e868143d07558ab14284a6c49cfdba159d23e54b07b74cceb9e90254196e63cd")
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

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("kcp")
    set_kind("$(kind)")
    add_files("ikcp.c")
    add_headerfiles("ikcp.h")
    if is_plat("windows", "mingw") then
        add_files("exports.def")
    else
        add_cflags("-fPIC")
        on_config(function(target)
            local is_clang = not not (target:toolchain("clang") or target:toolchain("clang-cl") or target:toolchain("zig"))
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
