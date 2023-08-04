local function getVersion(version)
    local versions ={
        ["2023.08.04"] = "archive/895b080a3c2189feaea0919af8982e9a248ff7d6.tar.gz",
    }
    return versions[tostring(version)]
end

package("sokol")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/floooh/sokol")
    set_description("Simple STB-style cross-platform libraries for C and C++, written in C.")
    set_license("zlib")

    set_urls(
        "https://github.com/floooh/sokol/$(version)"
    )
    add_versions("2023.08.04", "d5cdd99a259b6030ab4b7cba47e553399bd3c01fd6ad97901ac1dfe37e033a5b")

    on_install(function (package)
        os.cp("*.h", package:installdir("include"))
        os.cp("util/*.h", package:installdir("include", "util"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("sargs_setup", {includes = "sokol_args.h", defines = "SOKOL_IMPL"}))
    end)
