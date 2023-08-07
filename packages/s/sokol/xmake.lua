local function getVersion(version)
    local versions ={
        ["2023.08.05"] = "archive/47d92ff86298fc96b3b84d93d0ee8c8533d3a2d2.tar.gz",
    }
    return versions[tostring(version)]
end

package("sokol")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/floooh/sokol")
    set_description("Simple STB-style cross-platform libraries for C and C++, written in C.")
    set_license("zlib")

    set_urls(
        "https://github.com/floooh/sokol/$(version)",
        {
            version = getVersion
        }
    )
    add_versions("2023.08.05", "bfad73555e07e1f7a0b257f612ac62cb1f858169c39e1df1fd134431cdb07c64")

    on_install(function (package)
        os.cp("*.h", package:installdir("include"))
        os.cp("util/*.h", package:installdir("include", "util"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("sargs_setup", {includes = "sokol_args.h", defines = "SOKOL_IMPL"}))
    end)
