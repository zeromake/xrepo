local function getVersion(version)
    local versions ={
        ["2023.12.25-alpha"] = "archive/f45d73db67eaadc3df98971872add86f660a3ee5.tar.gz",
        ["2023.03.29-alpha"] = "archive/aa6917c02688ceb72d30fc31f34f0bdfc9b4a559.tar.gz",
        ["2024.04.25-alpha"] = "archive/12335ea226214440296927c8fe821dba9ee17d5a.tar.gz",
        ["2024.04.30-alpha"] = "archive/f98e6a64b190364a1b6a40e37070a6134fdac28c.tar.gz",
        ["2024.10.24-alpha"] = "archive/02ca0b6e96480ad53657b4aeafef42085e08c31a.tar.gz",
        ["2025.03.29-alpha"] = "archive/a07e6c5058834d11757294bc5541dbef8f72c818.tar.gz",
        --insert getVersion
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
        --insert version
        add_versions("2025.03.29-alpha", "903410d2a450a0f643aedc0a2abc9e90a7cae49d672c426c6fc07af1db866c0e")
        add_versions("2024.10.24-alpha", "93e951e551a6eb9d35dfa543a3deed6ecb3d51db73c812e4b2a65882c23168dd")
        add_versions("2024.04.30-alpha", "89594f7ff959d80316950154355d184997e61d604cd3f02ce14e0da7f88b9e01")
        add_versions("2024.04.25-alpha", "ac08fe1f8b0b79688c16fad2bcf27f711b7ed649d5b13e76069f4137491faff0")
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
