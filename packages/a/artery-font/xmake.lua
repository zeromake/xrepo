local function getVersion(version)
    local versions ={
        ["2024.05.01-alpha"] = "archive/888674220216d1d326c6f29cf89165b545279c1f.tar.gz",
        ["2024.06.30-alpha"] = "archive/af79386abe0857fe1c30be97eec760dbd84022c5.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("artery-font")
    set_homepage("https://github.com/Chlumsky/artery-font-format")
    set_description("Artery Atlas Font format library")
    set_license("MIT")
    set_urls("https://github.com/Chlumsky/artery-font-format/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2024.06.30-alpha", "8d4a88024d028df0a1848ce43e46685709c8eb86492e691d425b8b948df5083a")
    add_versions("2024.05.01-alpha", "afc956df834369d19a877baff0194822c0ed96f4da9e2a5697006911eac7e686")
    on_install(function (package)
        os.cp("artery-font/*.h", package:installdir("include/artery-font"))
        os.cp("artery-font/*.hpp", package:installdir("include/artery-font"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
