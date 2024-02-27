
local function getVersion(version)
    local versions ={
        ["2024.02.27"] = "archive/05fe1f8e3617cf2f84f461f7c6708fe8c17a151b.zip",
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
    add_versions("2024.02.27", "08af9ca0923ca0b792edd4589f41f27d7290382f7d50d8359b740f06cfe49120")

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
