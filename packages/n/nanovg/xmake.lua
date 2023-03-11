package("nanovg")
    set_homepage("https://github.com/memononen/nanovg")
    set_description("Antialiased 2D vector drawing library on top of OpenGL for UI and visualizations.")
    set_license("zlib")
    -- 如果在引用项目的上层有开发中的引用本地的
    local p = path.join(path.directory(os.projectfile()), "../nanovg")
    if os.exists(p) and os.isdir(p) then
        set_sourcedir(p)
    else
        set_urls("https://github.com/zeromake/nanovg/archive/b6e6f34fa1bd22e4a92885b37f60be264397521d.zip")
        add_versions("latest", "1095da85be813b7a0713ed0a2fa807012fb05af0121978a4f51b4ac68bb213a1")
    end
    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
