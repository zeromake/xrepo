package("fxz")
    set_homepage("https://github.com/conor42/fxz")
    set_description("FXZ Utils is a fork of XZ Utils. It adds a multi-threaded radix
    match finder and optimized encoder. The documentation, including this
    file, is based upon the XZ Utils documentation.")
    set_license("MIT")
    set_urls("https://github.com/conor42/fxz/archive/f12d7eb3ecebcfa5e2d3dc8a016772b3cd101f39.zip"), {version = function (version)
        local versions = {202201090037="f12d7eb3ecebcfa5e2d3dc8a016772b3cd101f39"}
        return versions[version]
    end}

    add_versions("202201090037", "dffa4ec239bd43db13b5cba8d18eecb3c34e10289d1c576cfb81066a0660e4c9")
    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)