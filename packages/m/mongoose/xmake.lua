
local function getVersion(version)
    local versions ={
        ["2023.08.04"] = "archive/98f3f7b1ce1df914b093ba303ad7170c37913cba.tar.gz",
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
    add_versions("2023.08.04", "5db0532ded934eaea28eab1a6ff626da6dc73d9e203a830e728cb9bec8fd0b38")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")
            target("mongoose")
                set_kind("$(kind)")
                add_headerfiles("mongoose.h")
                add_files("mongoose.c")
        ]])
        local configs = {}
        configs["kind"] = package:config("shared") and "shared" or "static"
        import("package.tools.xmake").install(package, configs)
    end)
