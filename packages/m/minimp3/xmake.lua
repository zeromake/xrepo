local function getVersion(version)
    local versions ={
        ["2021.11.30-alpha"] = "archive/afb604c06bc8beb145fecd42c0ceb5bda8795144.tar.gz",
    }
    return versions[tostring(version)]
end
package("minimp3")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/lieff/minimp3")
    set_description("Minimalistic MP3 decoder single header library")
    set_license("CC0-1.0")
    set_urls("https://github.com/lieff/minimp3/$(version)", {
        version = getVersion
    })

    add_versions("2021.11.30-alpha", "21672c32aaac29cf4b7e6f8e0154767080ae87faa79c682498453e5a9bc5e0d3")
    on_install(function (package)
        os.cp("*.h", package:installdir("include/minimp3"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
