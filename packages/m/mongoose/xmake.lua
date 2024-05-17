
local function getVersion(version)
    local versions ={
        ["2024.02.27-alpha"] = "archive/05fe1f8e3617cf2f84f461f7c6708fe8c17a151b.tar.gz",
    }
    return versions[tostring(version)]
end

package("mongoose")
    set_urls("https://github.com/xfangfang/mongoose/$(version)",
        {
            version = getVersion
        }
    )
    add_versions("2024.02.27-alpha", "5669f3939e874995493a2c059436b5b520a9eb03487651b05ab042fc01cd0f73")

    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end
target("mongoose")
    set_kind("$(kind)")
    add_headerfiles("mongoose.h")
    add_files("mongoose.c")
]], {encoding = "binary"})
        local configs = {}
        configs["kind"] = package:config("shared") and "shared" or "static"
        import("package.tools.xmake").install(package, configs)
    end)
