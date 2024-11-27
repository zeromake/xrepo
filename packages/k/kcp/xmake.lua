
local function getVersion(version)
    local versions ={
        ["2023.05.07-alpha"] = "archive/f2aa30ea21a63c9ceeb6393e7d5d0c85a05a52a7.tar.gz",
        ["2024.04.09-alpha"] = "archive/7a878bf3587bcdaa358c43e5bccb372006011d25.tar.gz",
        ["2024.07.18-alpha"] = "archive/7440cdaeb711db16a0be4b824e1a2053daa099e3.tar.gz",
        ["2024.10.11-alpha"] = "archive/94385a10f86c0a773780cbfd61445ed3957a4ce2.tar.gz",
        ["2024.10.16-alpha"] = "archive/ecafc2b299a7b9c84b776c42ab2497277936a1db.tar.gz",
        ["2024.11.23-alpha"] = "archive/b4a0aba445c924b39f981525345723c66dc9814e.tar.gz",
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
    add_versions("2024.11.23-alpha", "c751b75269aff022b44eae13052b628334ae770fdc5a23ce1787f0f93a2ce2a6")
    add_versions("2024.10.16-alpha", "b9f64c1e55300b04acd7ad793ca088327afb9620e8acb52ae503eb2362a70b7b")
    add_versions("2024.10.11-alpha", "00fa26ad5a32f179b3aeb680a87aa804d37c3f37e76607702cd4cb6cf9800bc4")
    add_versions("2024.07.18-alpha", "27a1f089b7f2d2ba552ef70c603d9b92253088d26837d153219bf363e40a8bd2")
    add_versions("2024.04.09-alpha", "6c17ca320d793a7f639cf8e95e4d41aadf2061958474cad73efc6e23ca9e658d")
    add_versions("2023.05.07-alpha", "5bfa9fb6de27f23e263be5398dddc443348008a94fd287ece80a5b98207b2e37")
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
