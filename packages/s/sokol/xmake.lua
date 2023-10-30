local function getVersion(version)
    local versions ={
        ["2023.08.05"] = "archive/47d92ff86298fc96b3b84d93d0ee8c8533d3a2d2.tar.gz",
        ["2023.10.07"] = "archive/d98c8b92c25070f13d0491f5fade1d9d2ca885ad.tar.gz",
        ["2023-10-27"] = "archive/9e0f1b4e550998127c8f884ff7cc63838cf61860.tar.gz",
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
    add_versions("2023-10-27", "c1f992e201d223b622551331961b3fc8a52f6f652d9cb99832b0aabe701ff7c1")
    add_versions("2023.10.07", "8feafbe69626fa33d071ebeef158431fab4831c77e60fff91a6f659ba34d0353")
    add_versions("2023.08.05", "bfad73555e07e1f7a0b257f612ac62cb1f858169c39e1df1fd134431cdb07c64")

    on_install(function (package)
        os.cp("*.h", package:installdir("include"))
        os.cp("util/*.h", package:installdir("include", "util"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("sargs_setup", {includes = "sokol_args.h", defines = "SOKOL_IMPL"}))
    end)
