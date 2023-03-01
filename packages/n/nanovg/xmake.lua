package("nanovg")
    set_homepage("https://github.com/memononen/nanovg")
    set_description("Antialiased 2D vector drawing library on top of OpenGL for UI and visualizations.")
    set_license("zlib")
    -- 如果在引用项目的上层有开发中的引用本地的
    local p = path.join(path.directory(os.projectfile()), "../nanovg")
    if os.exists(p) and os.isdir(p) then
        set_sourcedir(p)
    else
        set_urls("https://github.com/zeromake/nanovg/archive/6703a13d4223677e284a2cd135b8e3c5bdd0dff4.zip")
        add_versions("latest", "f57f1612395ed39bc0f69777e161c49a417ac6ccf4153f725dd458b14816397a")
    end
    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
