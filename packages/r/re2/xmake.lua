local function getVersion(version)
    return tostring(version):gsub("%.", "-")
end
package("re2")
    set_homepage("https://github.com/google/re2")
    set_description("RE2 is a fast, safe, thread-friendly alternative to backtracking regular expression engines like those used in PCRE, Perl, and Python.")
    set_license("MIT")
    set_urls("https://github.com/google/re2/releases/download/$(version)/re2-$(version).tar.gz", {
        version = getVersion
    })

    --insert version
    add_versions("2024.06.01", "7326c74cddaa90b12090fcfc915fe7b4655723893c960ee3c2c66e85c5504b6c")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
