local function getVersion(version)
    local versions ={
        ["2024.07.24-alpha"] = "archive/cf7438bd7865f0fc98a5aee8526308fcaa398926.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("sokol-wayland")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/floooh/sokol")
    set_description("Simple STB-style cross-platform libraries for C and C++, written in C.")
    set_license("zlib")

    set_urls("https://github.com/digitalsignalperson/sokol-custom/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2024.07.24-alpha", "de229e1065ef4ef8dcd9119f67ad2d88a30d8bca38faa76f2c70a338cb4ccdfc")

    on_install(function (package)
        os.cp("*.h", package:installdir("include"))
        os.cp("util/*.h", package:installdir("include", "util"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("sargs_setup", {includes = "sokol_args.h", defines = "SOKOL_IMPL"}))
    end)
