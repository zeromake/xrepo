local function getVersion(version)
    local versions ={
        ["2023.12.25-alpha"] = "archive/f45d73db67eaadc3df98971872add86f660a3ee5.tar.gz",
        ["2023.03.29-alpha"] = "archive/aa6917c02688ceb72d30fc31f34f0bdfc9b4a559.tar.gz",
        ["2024.04.25-alpha"] = "archive/002881af4804e58d8d980805186999d8c61a26a1.tar.gz",
    }
    return versions[tostring(version)]
end

package("nanovg")
    set_homepage("https://github.com/memononen/nanovg")
    set_description("Antialiased 2D vector drawing library on top of OpenGL for UI and visualizations.")
    set_license("zlib")
    -- 如果在引用项目的上层有开发中的引用本地的
    local p = path.join(path.directory(os.projectfile()), "../nanovg")
    if os.exists(p) and os.isdir(p) then
        set_sourcedir(p)
    else
        set_urls("https://github.com/zeromake/nanovg/$(version)",
            {
                version = getVersion
            }
        )
        add_versions("2024.04.25-alpha", "ebca1482a7a2db77df9714caf9a766df4e5167d524aceab1eb3650df6cfb7893")
        add_versions("2023.12.25-alpha", "65d2285824134fb71e03337e4bfaead4a84831e242b5e0d3d9a83cb612250260")
        add_versions("2023.03.29-alpha", "852bfeaf9095c6b4550fbde48357c71b323c6c508f97f1025248583d85c8e1dc")
    end
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
