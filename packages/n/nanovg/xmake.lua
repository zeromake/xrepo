package("nanovg")
    set_homepage("https://github.com/memononen/nanovg")
    set_description("Antialiased 2D vector drawing library on top of OpenGL for UI and visualizations.")
    set_license("zlib")
    -- 如果在引用项目的上层有开发中的引用本地的
    local p = path.join(path.directory(os.projectfile()), "../nanovg")
    if os.exists(p) and os.isdir(p) then
        set_sourcedir(p)
    else
        set_urls("https://github.com/zeromake/nanovg/archive/04f425e88b250de74fa3a1a518036bdc2c136921.zip")
        add_versions("latest", "4750b047350498458d9a53189b8c12554db3717b7fc2c8f27626e2d3ec041a28")
    end
    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
