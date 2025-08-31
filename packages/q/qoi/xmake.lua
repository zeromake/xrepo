local function getVersion(version)
    local versions ={
        ["2025.02.12-alpha"] = "archive/d0cf1dfcc371f894da88a8d5fb3b08c2e8ad7474.tar.gz",
        ["2025.05.09-alpha"] = "archive/4461cc37ef08b24f157a5ab7c3f7d6c9e6caa6c0.tar.gz",
        ["2025.07.08-alpha"] = "archive/316593b6de3576743506d4115e30bf03a12b587d.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("qoi")
    set_homepage("https://qoiformat.org")
    set_description("The “Quite OK Image Format” for fast, lossless image compression")
    set_license("MIT")
    set_urls("https://github.com/phoboslab/qoi/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2025.07.08-alpha", "599c49ce80eae85afe1d88221e74950e9191840123bf4eb727759e67e493c05a")
    add_versions("2025.05.09-alpha", "b1daf276b81b737de50ab3f49a17f6a0ae6b13ad6af9d38fa1be052a2e5c59c1")
    add_versions("2025.02.12-alpha", "16476f43ab4a639185748d13d6bb0a0c2c74c667432882801e53d76d61f3a928")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        -- support for jpg and jpeg
        io.replace(
            "qoiconv.c",
            [[(STR_ENDS_WITH(argv[1], ".png")]],
            [[(STR_ENDS_WITH(argv[1], ".png") || STR_ENDS_WITH(argv[1], ".jpg") || STR_ENDS_WITH(argv[1], ".jpeg")]],
            { plain = true, encoding = "utf-8" }
        )
        io.replace(
            "qoiconv.c",
            [[#define STBI_ONLY_PNG]],
            [[]],
            { plain = true, encoding = "utf-8" }
        )
        import("package.tools.xmake").install(package, configs)
        os.cp("qoi.h", package:installdir("include"))
        package:addenv("PATH", "bin")
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
