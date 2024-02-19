
local function getVersion(version)
    local versions ={
        ["2024.02.18"] = "archive/2d4dbaffe8cd02ee83495c7c1446f92536d6bb53.zip",
    }
    return versions[tostring(version)]
end

package("mongoose")
    set_urls(
        "https://github.com/xfangfang/mongoose/$(version)",
        {
            version = getVersion
        }
    )
    add_versions("2024.02.18", "df1c52a99524d89ea8ea983cf96f9875086590e77872eb598ec57dc5179c3d2e")

    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
target("mongoose")
    set_kind("$(kind)")
    add_headerfiles("mongoose.h")
    add_files("mongoose.c")
]], {encoding = "binary"})
        local configs = {}
        configs["kind"] = package:config("shared") and "shared" or "static"
        import("package.tools.xmake").install(package, configs)
    end)
